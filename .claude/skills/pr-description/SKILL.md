---
name: pr-description
description: Prepares a pull request description. Use when asked to write or draft a PR description.
---

# PR Description Style

Write PR descriptions following these conventions:

## Title

- Imperative mood: "Add feature" not "Added feature"
- Capitalize the first letter
- Be descriptive; longer than commit subjects is fine

## Body Structure

1. **Issue link** (if applicable): Start or end with `Part of <url>` or `Fixes <url>`
2. **Why**: Explain WHY this change is needed - the problem, context, or motivation
3. **Assumptions**: Call out any assumptions made or decisions that reviewers should know about
4. **Code references**: Link directly to specific code when relevant (see below)

## What NOT to do

- Don't write bullet points listing what you did (e.g., "- Updated X", "- Added Y", "- Fixed Z")
- Reviewers can see what changed in the diff; the description should explain WHY

## Code References

When referencing code, use permanent links with the commit SHA, not `main`:

Good: `https://github.com/shop/world/blob/845bb9d9e90c30668470d808593389397f4e89bd/path/to/file.rb#L691-L695`

Bad: `https://github.com/shop/world/blob/main/path/to/file.rb#L691-L695`

This ensures links don't break when code moves after the PR merges.

## Optional Sections

- `## Questions for reviewers` - When you need input on specific decisions
- `### Before / ### After` - For visual changes, include screenshots
- `<details><summary>...</summary>...</details>` - For verbose info like stacktraces or long code samples
- Links to related PRs when relevant

## Example

```markdown
Part of https://github.com/shop/issues-team/issues/123

When identity isn't running in development, the UserLimits field was returning "Field 'userLimits' doesn't exist" because visibility checks were failing.

The UserLimits type requires USER_ACCESS scope. Even though mock API scopes were being returned, the context had `user_access: false` because the mock token didn't have a `sub` claim. The fix adds the missing claim and corresponding context overrides.

I assumed we only need this for development mode - if we need similar behavior in test, we'd need to extend `TestContextOverrides` as well.

The key change is in [DevelopmentContextOverrides](https://github.com/shop/world/blob/a1b2c3d/path/to/file.rb#L45-L52) where we now check for the sub claim before setting user_access.

## Questions for reviewers

Should we add similar overrides for other scopes?
```

## Output

1. Run `ruby ~/.claude/skills/pr-description/context.rb` to get branch name, main SHA, commits, and diff stats
2. If the diff stats aren't enough context, run the full diff command printed at the end of the script output
3. Write the PR description to `~/.claude/local-notes/pr-descriptions/pr-<branch_name>.md` using GitHub flavored markdown
4. Copy to clipboard: `cat ~/.claude/local-notes/pr-descriptions/pr-<branch_name>.md | pbcopy`
5. Tell the user it's been copied and mention the file path in case they need to retrieve it later
