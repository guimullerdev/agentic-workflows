# Git conventions (per project)

Single source of truth for how `run-phase`, `jira-plan` and `pr-create` name branches,
title PRs and decide how many PRs to open. Each project declares its own in `CLAUDE.md`:

```markdown
## Git conventions
- PR granularity: ticket
- Branch: {key}/{slug}
- PR title: {key} {type}: {summary}
- Plan: local
```

Read the section from the project's `CLAUDE.md` (or `.claude/CLAUDE.md`). Missing section or
missing line → use the default for that line. Do not guess a convention from elsewhere.

## Fields

| Field | Values | Default |
|---|---|---|
| `PR granularity` | `task` · `ticket` | `task` |
| `Branch` | pattern with placeholders | `{type}/{key}-{slug}` with a key; `{type}/{phase}-{slug}` with a phase and no key; `{type}/{slug}` otherwise |
| `PR title` | pattern with placeholders | `{key} {type}: {summary}` with a key, `{type}: {summary}` without |
| `Plan` | `commit` · `local` | `commit` |

- **`task`**: one task = one branch = one PR (one phase can open several PRs).
- **`ticket`**: one Jira key = one branch = one PR. Every task carrying the same key goes
  into the same branch, one commit per task. With no key (plan without Jira), the phase
  plays the role of the ticket: one phase = one PR.
- **`Plan: commit`**: `docs/PLAN.md` is versioned; `plan-create`/`jira-plan` and the plan
  updates of `run-phase` go in their own `docs:` PR.
- **`Plan: local`**: `docs/PLAN.md` is a local working file, never committed and never a PR
  (use it where the team does not want plan files in the repo, or where every PR must map to
  a ticket). Add `docs/PLAN.md` to `.git/info/exclude` so it stays out of commits without
  touching the repo's `.gitignore`.

## Placeholders

| Placeholder | Value |
|---|---|
| `{key}` | Jira key of the phase (`PROJ-123`). Pattern uses `{key}` and the phase has no key → fall back to the default pattern without key |
| `{type}` | Conventional Commits type of the change: `feat`, `fix`, `chore`, `docs`, `refactor`, `test` |
| `{phase}` | phase number in the plan (`3`) |
| `{slug}` | kebab-case, English, verb + object, ≤ 5 words (`add-login-form`) |
| `{summary}` | imperative summary, lower case, ≤ 72 chars counting the prefix |

Examples with `Branch: {key}/{slug}`: `PROJ-123/add-login-form`, `PROJ-88/fix-token-refresh`.

## Ticket types (used by `jira-plan` with `PR granularity: ticket`)

- **Epic** → each child issue is its own ticket: one or more phases per child, `Jira:` = the
  child's key, one PR per child. Never merge two children into one phase.
- **Any other type** (story, task, bug, …) → the issue is one ticket: `Jira:` = the issue's key
  on every phase, and its subtasks are scope of the ticket, never their own PRs.

A ticket split into several phases still has one branch and one PR: a later run reuses the
existing branch and pushes new commits to the open PR.

With `PR granularity: task`, `jira-plan` keeps mapping 1 subtask = 1 phase with the subtask's
key, and PRs stay one per task.
