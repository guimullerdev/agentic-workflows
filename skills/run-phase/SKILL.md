---
name: run-phase
description: >-
  Executes one or more phases of a project plan (docs/PLAN.md or similar): splits
  them into tasks, rates each by difficulty and picks the model (haiku/sonnet/opus)
  and effort, runs independent tasks in parallel in worktrees and leaves one PR per
  task, or one PR per ticket when the project's Git conventions say so. Use when the user says "run phase 1", "execute phases 1 and 2", "implement
  the next phase of the plan" or types /run-phase.
argument-hint: "<phase> [phase...] [--plan path] [--dry-run]"
---

# run-phase

## Non-negotiable rules
- Never commit to `main`. One PR per task, or per ticket with `PR granularity: ticket`
  (see `../pr-create/reference/git-conventions.md`).
- Never add AI attribution (Co-Authored-By: Claude, "Generated with Claude Code", mentions of Claude) in commits, branches, PRs or comments.
- Never merge. Merging is the user's job.
- Two tasks that touch the same file do **not** run in parallel.
- Without a plan approved by the user, nothing is implemented.

## Steps

### 1. Locate the plan
Look in this order: `--plan`, `docs/PLAN.md`, `PLAN.md`, `ROADMAP.md`.

If the only plan found is `docs/PLANO.md`, or the plan uses Portuguese headers, stop without parsing it and tell the user to migrate (rename to `docs/PLAN.md` and switch to the English headers).

Phase headers are English only: Phase N, Goal, Jira, Depends on, Scope, Out of scope,
Likely files, Done criteria, Risk, Open questions, and the checkbox `- [ ] done` (or `- [x] done`).
The "next phase" is the first one with an unchecked box.
Also read `CLAUDE.md`, `CONTRIBUTING.md` and `.claude/review-rules.md` if they exist.
From `CLAUDE.md`, take the **Git conventions** section (PR granularity, Branch, PR title, Plan) as
described in `../pr-create/reference/git-conventions.md`; missing lines use the defaults there.

### 2. Plan (subagent `phase-planner`)
Pass the requested phases, the files above and the **PR granularity**, and say whether
**opus is available** (see "Opus unavailable" below). It returns the table:

| # | Task | Jira | Files | Depends on | V | R | Model | Effort | Done criteria |

Scoring, model and effort: see `reference/model-selection.md` (copy of
docs/best-practices/model-selection.md). Summary: **V** (volume) picks the model,
**R** (reasoning) picks the effort.

### 3. Confirm with the user
Show the table, the parallel "batches" and the **branches/PRs** that will be opened
(one line per branch: name, tasks it carries). With `--dry-run`, stop here.
The user may change the model and effort of any task.

### 4. Execute in batches
For each batch (tasks with no pending dependency and no files in common):
- Haiku → agent `implementer-fast`
- Sonnet → agent `implementer`
- Opus → agent `architect` produces the spec; then `implementer` implements
- Pass `effort` to the agent per the table's Effort column (R 0–1 → pass nothing).
  `max` only if the user asks.
- Branch names follow the `Branch` pattern (default `{type}/{key}-{slug}`, e.g.
  `feat/PROJ-124-login-form`; `{type}/{phase}-{slug}` when the phase has no `Jira` field).
- **`PR granularity: task`** (default): each agent with `isolation: "worktree"` on its own
  branch, one branch per task.
- **`PR granularity: ticket`**: one branch and one worktree per ticket (Jira key; no key →
  per phase). Create it yourself: `git worktree add ../<repo>-wt/<branch> -b <branch> <base>`,
  e.g. branch `PROJ-123/add-login-form` (`{slug}` from the ticket, not from a task). Agents run **without** `isolation`, and their prompt
  says "work only inside `<worktree path>`". Tasks of the same ticket run **one after
  another** in that worktree; after each green task, commit it there (`<type>: <task>`,
  Conventional Commits). Different tickets have different worktrees, so they still run in
  parallel when they share no files.
  Ticket branch already exists (earlier run, phase split in two)? Reuse it: worktree on that
  branch (`git worktree add <path> <branch>`), new commits on top, and the push updates the
  PR that is already open instead of opening another.
- Each agent's prompt: task, files, done criteria, test command,
  "do not touch other files" and "return in the standard block" (output contract in
  `reference/output-contract.md`). Do not pass raw JSON or conversation history.
- **Call log:** before each Agent call, write a visible line
  `▶ T<#> <task> → <agent> · <model> · effort <effort|default> · worktree <branch>`
  and, on return, `✔/✖ T<#> <agent> (<model>) — <1-line summary>`. This also applies
  to `phase-planner`, `architect`, retries and escalations. Keep every line for
  the final report.

### 4b. Opus unavailable
The account may not have opus at the moment. Never downgrade silently:
- The `phase-planner` and `architect` agents use `model: inherit`. Without opus, call them on
  the session model with `effort: xhigh`.
- Task marked opus in the table → run `sonnet` + `effort: xhigh` and show it in the table as
  `sonnet + xhigh (was opus)`.
- Tell the user, in one line, which tasks were downgraded, before executing. They
  may prefer to wait for opus on high-risk tasks (R ≥ 5).

### 5. Verify
For each task: run the tests in the worktree and check `git diff --stat`; open the full
diff only if something failed or looks wrong. In ticket mode, verify each task before the
next one of the same ticket starts, and do not commit a red task. On failure, send it back to the
same agent with the error (max 2 times). Still failing: raise **one** level — effort
first, and only then the model (effort is cheaper than switching models).

### 6. PRs
Use the `pr-create` skill on each green branch, passing the branch and the PR title built
from the `PR title` pattern (default `{key} {type}: {summary}`, e.g. `PROJ-124 feat: add login
form`). In the PR, cite the phase and the task(s); in ticket mode, list every task of the
ticket under "What changed". Phase with a `Jira` field → key in the title and in the Context,
so Jira links the PR on its own. A ticket only gets its PR when **all** its tasks in this
run are green; otherwise report which ones failed and leave the branch without a PR.
Do not write to Jira.

### 7. Report
Final table, one row per agent call (including planner, architect and retries):

| # | Task | Agent | Model | Effort | Attempt | Result | PR |

Flag downgrades (`sonnet + xhigh (was opus)`) and escalations (`effort high→xhigh`).
Then: totals per model (e.g. `haiku 3 · sonnet 5 · opus 1`) and what is still pending.
Update the plan by marking completed tasks: in its own `docs:` PR with `Plan: commit`
(default); with `Plan: local`, only edit the file, no commit and no PR.
