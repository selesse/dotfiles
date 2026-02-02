---
name: commit-message
description: Prepares a git commit message. Use when asked to write or draft a commit message.
---

# Commit Message Style

Write commit messages following these conventions:

## Subject Line

- Imperative mood: "Add feature" not "Added feature" or "Adds feature"
- Capitalize the first letter
- No period at the end
- No conventional prefixes (no `fix:`, `feat:`, etc.)
- Use backticks for code, commands, or identifiers (e.g., `dev up`, `find_or_create_by`)

## Body (when needed)

- Separate from subject with a blank line
- Wrap at 72 characters
- Write in prose paragraphs, not bullet points
- Explain the WHY, not the HOW:
  - Describe the problem or context first
  - Then explain why this solution was chosen
- Skip the body if the subject is self-explanatory

## Examples

Subject-only (self-explanatory change):
```
Bump batch size to 50k
```

With body (needs context):
```
Use find_or_create_by for providers

create_or_find_by tries INSERT first, then SELECT on failure. Since
providers are a small, static set (created once, found many times), this
was hitting the error path on almost every call, causing slow writes and
noisy logs.

find_or_create_by does SELECT first, only INSERTing when needed. The
existing retry logic handles the rare race condition.
```

## Output

Return the commit message as plain text. Do not wrap in markdown code blocks. Do not run `git commit`.
