#!/usr/bin/env ruby
# frozen_string_literal: true

# Gathers context needed for writing PR descriptions.
# Run from any git repo.
#
# Usage: ruby context.rb [main_branch]

main_branch = ARGV[0] || "main"

def run(cmd)
  output = `#{cmd}`.strip
  abort("Failed: #{cmd}") unless $?.success?
  output
end

branch = run("git branch --show-current")
main_sha = run("git rev-parse origin/#{main_branch}")
commits = run("git log #{main_branch}..HEAD")
diff_stats = run("git diff --stat #{main_branch}..HEAD")

puts "=== Branch ==="
puts branch
puts
puts "=== Main SHA (for permalinks) ==="
puts main_sha
puts
puts "=== Commits ==="
puts commits
puts
puts "=== Diff stats ==="
puts diff_stats
puts
puts "=== Full diff command ==="
puts "git diff #{main_branch}..HEAD"
