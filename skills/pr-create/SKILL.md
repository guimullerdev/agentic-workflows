---
name: pr-create
description: >-
  Creates a branch, Conventional Commits, pushes and opens a Pull Request with a
  structured description following the project's standards. Use when the user
  asks to open a PR, "send it to review", "push this up", "wrap up this change"
  or types /pr-create.
argument-hint: "[title] [--draft] [--base main]"
allowed-tools: Bash(git:*), Bash(gh:*), Bash(yarn:*), Bash(npm:*), Bash(pnpm:*), Read, Grep
---

# pr-create

## Non-negotiable rules
- Never commit/push directly to the base branch.
- Never merge, never `--force` without an explicit request.
- No AI attribution in commits, branch, title or description (Co-Authored-By,
  "Generated with", etc.), unless the project's CLAUDE.md says otherwise.
- Green tests before pushing.

## Steps
1. `git status --short`, `git branch --show-current`. If on the base branch,
   create `feat|fix|chore|docs|refactor/<slug>`.
2. Find the test command (`CLAUDE.md`, `CONTRIBUTING.md`, `package.json`) and run it.
   Red → stop and report.
3. Commits: Conventional Commits, English, imperative, ≤ 72 chars. Split by
   concern (e.g. `test:` and `feat:`) when it makes sense.
4. `git push -u origin <branch>`.
5. If `.github/pull_request_template.md` exists, fill it in. Otherwise use:

```markdown
## Context
<why; link to issue/plan phase>

## What changed
- ...

## How to test
1. ...

## Checklist
- [ ] Tests added/updated
- [ ] No secrets / sensitive data
- [ ] Docs updated (if applicable)
```

6. `gh pr create --base <base> --title "<conventional title>" --body-file <tmp>` (`--draft` if requested).
7. Return the PR link. Do not merge.
