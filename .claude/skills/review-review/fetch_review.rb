#!/usr/bin/env ruby
# frozen_string_literal: true

# Fetches all PR comments + review comments via a single GraphQL call.
# Filters bot noise, threads inline comments with diff context.
#
# Usage: ruby fetch_review.rb <pr-url-or-number> [owner/repo]
#
# Examples:
#   ruby fetch_review.rb 491550
#   ruby fetch_review.rb https://github.com/shop/world/pull/491550
#   ruby fetch_review.rb 123 Shopify/some-repo

require "json"
require "open3"

ALLOWED_BOTS = %w[
  binks-code-reviewer
].freeze

GRAPHITE_STACK_MARKER = "This stack of pull requests is managed by"

def parse_args
  input = ARGV[0] || abort("Usage: ruby fetch_review.rb <pr-url-or-number> [owner/repo]")

  pr_number = input[/(\d+)/, 1] || abort("Could not extract PR number from: #{input}")

  repo = if ARGV[1]
    owner, name = ARGV[1].split("/")
    { owner: owner, name: name }
  elsif input.match?(%r{github\.com/})
    match = input.match(%r{github\.com/([^/]+)/([^/]+)/pull/})
    match ? { owner: match[1], name: match[2] } : { owner: "shop", name: "world" }
  elsif input.match?(%r{graphite\.(com|dev)/})
    match = input.match(%r{graphite\.(?:com|dev)/github/pr/([^/]+)/([^/]+)/(\d+)})
    match ? { owner: match[1], name: match[2] } : { owner: "shop", name: "world" }
  else
    { owner: "shop", name: "world" }
  end

  [pr_number.to_i, repo]
end

QUERY = File.read(File.join(__dir__, "pr_comments.graphql"))

INT_VARS = %w[number].freeze

def gh_graphql(variables)
  cmd = ["gh", "api", "graphql", "-f", "query=#{QUERY}"]
  variables.each do |k, v|
    flag = INT_VARS.include?(k.to_s) ? "-F" : "-f"
    cmd.push(flag, "#{k}=#{v}")
  end

  stdout, stderr, status = Open3.capture3(*cmd)
  abort("gh api failed: #{stderr}") unless status.success?
  JSON.parse(stdout, symbolize_names: true)
end

def fetch_all(pr_number, repo)
  all_comments = []
  all_reviews = []
  pr_data = nil

  comments_cursor = nil
  reviews_cursor = nil

  loop do
    vars = { owner: repo[:owner], name: repo[:name], number: pr_number.to_s }
    vars[:commentsCursor] = comments_cursor if comments_cursor
    vars[:reviewsCursor] = reviews_cursor if reviews_cursor

    result = gh_graphql(vars)
    pr = result.dig(:data, :repository, :pullRequest)
    abort("PR not found: #{pr_number}") unless pr

    pr_data ||= pr

    all_comments.concat(pr[:comments][:nodes])
    all_reviews.concat(pr[:reviews][:nodes])

    comments_has_more = pr[:comments][:pageInfo][:hasNextPage]
    reviews_has_more = pr[:reviews][:pageInfo][:hasNextPage]

    comments_cursor = pr[:comments][:pageInfo][:endCursor] if comments_has_more
    reviews_cursor = pr[:reviews][:pageInfo][:endCursor] if reviews_has_more

    break unless comments_has_more || reviews_has_more
  end

  [pr_data, all_comments, all_reviews]
end

def bot?(author)
  return true unless author
  author[:__typename] == "Bot"
end

def allowed_author?(author)
  return false unless author
  return true unless bot?(author)

  ALLOWED_BOTS.include?(author[:login])
end

def graphite_stack_comment?(body)
  body&.include?(GRAPHITE_STACK_MARKER)
end

INDENT = "    "

def indent(text)
  text.gsub(/^/, INDENT)
end

def format_diff_context(diff_hunk)
  return nil unless diff_hunk
  lines = diff_hunk.lines.last(10).map(&:rstrip)
  lines.join("\n")
end

def author_label(author)
  login = author&.dig(:login) || "unknown"
  bot?(author) ? "#{login} [BOT]" : login
end

def format_output(pr_data, comments, reviews)
  out = []

  out << "# PR ##{pr_data[:url][/\d+$/]}: #{pr_data[:title]}"
  out << "Author: #{pr_data.dig(:author, :login)} | State: #{pr_data[:state]}"
  out << ""

  if pr_data[:body] && !pr_data[:body].strip.empty?
    out << "## Description"
    out << pr_data[:body].strip
    out << ""
  end

  visible_comments = comments.select { |c| allowed_author?(c[:author]) && !graphite_stack_comment?(c[:body]) }
  if visible_comments.any?
    out << "## General Comments"
    visible_comments.each do |c|
      out << "**#{author_label(c[:author])}** (#{c[:createdAt]}):"
      out << indent(c[:body].strip)
      out << ""
    end
  end

  inline_comments = []
  review_bodies = []

  reviews.each do |r|
    next unless allowed_author?(r[:author])

    if r[:body] && !r[:body].strip.empty?
      review_bodies << {
        author: r[:author],
        state: r[:state],
        body: r[:body].strip,
        created_at: r[:createdAt],
      }
    end

    r[:comments][:nodes].each do |c|
      next unless allowed_author?(c[:author])
      inline_comments << c
    end
  end

  if review_bodies.any?
    out << "## Review Summaries"
    review_bodies.each do |r|
      out << "**#{author_label(r[:author])}** [#{r[:state]}] (#{r[:created_at]}):"
      out << indent(r[:body])
      out << ""
    end
  end

  if inline_comments.any?
    threads = {}
    top_level = []

    inline_comments.each do |c|
      if c[:replyTo]
        (threads[c[:replyTo][:id]] ||= []) << c
      else
        top_level << c
        threads[c[:id]] ||= []
      end
    end

    out << "## Inline Review Comments"
    top_level.each do |c|
      out << "---"
      location = c[:path].dup
      location << ":#{c[:startLine]}-#{c[:line]}" if c[:startLine] && c[:line]
      location << ":#{c[:line]}" if !c[:startLine] && c[:line]
      out << "### `#{location}`"

      diff = format_diff_context(c[:diffHunk])
      if diff
        out << "```diff"
        out << diff
        out << "```"
      end

      out << "**#{author_label(c[:author])}** (#{c[:createdAt]}):"
      out << indent(c[:body].strip)

      replies = threads[c[:id]] || []
      replies.sort_by { |r| r[:createdAt] }.each do |reply|
        out << ""
        out << "  > **#{author_label(reply[:author])}** (#{reply[:createdAt]}):"
        out << indent("> #{reply[:body].strip.gsub("\n", "\n> ")}")
      end

      out << ""
    end
  end

  out.join("\n")
end

pr_number, repo = parse_args
pr_data, comments, reviews = fetch_all(pr_number, repo)
puts format_output(pr_data, comments, reviews)
