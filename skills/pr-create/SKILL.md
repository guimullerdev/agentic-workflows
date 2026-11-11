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
- Branch and title follow the project's **Git conventions** (`CLAUDE.md`), described in
  `reference/git-conventions.md`.

## Steps
1. `git status --short`, `git branch --show-current`. Read the **Git conventions** section
   of `CLAUDE.md`. If on the base branch, create the branch from the `Branch` pattern
   (default `{type}/{slug}`, or `{type}/{key}-{slug}` when there is a Jira key, e.g.
   `PROJ-123/add-login-form` with `Branch: {key}/{slug}`). Jira key: argument, the caller
   (`run-phase`), or ask if the pattern needs one. Already on a non-base branch → keep it.
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

6. Branch already has an open PR (`gh pr view --json url,state`)? The push already updated
   it: return its link and stop. Otherwise
   `gh pr create --base <base> --title "<title>" --body-file <tmp>` (`--draft` if requested),
   with the title from the `PR title` pattern (default `{key} {type}: {summary}`, or
   `{type}: {summary}` without a key).
7. Return the PR link. Do not merge.
