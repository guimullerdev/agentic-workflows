---
name: run-phase
description: >-
  Executes one or more phases of a project plan (docs/PLAN.md or similar): splits
  them into tasks, rates each by difficulty and picks the model (haiku/sonnet/opus)
  and effort, runs independent tasks in parallel in worktrees and leaves one PR per
  task. Use when the user says "run phase 1", "execute phases 1 and 2", "implement
  the next phase of the plan" or types /run-phase.
argument-hint: "<phase> [phase...] [--plan path] [--dry-run]"
---

# run-phase

## Non-negotiable rules
- Never commit to `main`. One task = one branch = one PR.
- Never add AI attribution (Co-Authored-By: Claude, "Generated with Claude Code", mentions of Claude) in commits, branches, PRs or comments.
- Never merge. Merging is the user's job.
- Two tasks that touch the same file do **not** run in parallel.
- Without a plan approved by the user, nothing is implemented.

## Steps

### 1. Locate the plan
Look in this order: `--plan`, `docs/PLAN.md`, `PLAN.md`, `docs/PLANO.md` (legacy fallback), `ROADMAP.md`.

Phases may use English headers or the legacy Portuguese ones. Treat them as equivalent:
Phase N = Fase N; Goal = Objetivo; Jira = Jira; Depends on = Depende de; Scope = Escopo;
Out of scope = Fora de escopo; Likely files = Arquivos prováveis; Done criteria = Critério de pronto;
Risk = Risco; Open questions = Perguntas em aberto; checkbox `- [ ] done` = `- [ ] concluída` (and `[x]`).
The "next phase" is the first one with an unchecked box, in either language. When marking
completion, use the same language the plan already uses.
Also read `CLAUDE.md`, `CONTRIBUTING.md` and `.claude/review-rules.md` if they exist.

### 2. Plan (subagent `phase-planner`)
Pass the requested phases and the files above, and say whether **opus is available**
(see "Opus unavailable" below). It returns the table:

| # | Task | Files | Depends on | V | R | Model | Effort | Done criteria |

Scoring, model and effort: see `reference/model-selection.md` (copy of
docs/best-practices/model-selection.md). Summary: **V** (volume) picks the model,
**R** (reasoning) picks the effort.

### 3. Confirm with the user
Show the table and the parallel "batches". With `--dry-run`, stop here.
The user may change the model and effort of any task.

### 4. Execute in batches
For each batch (tasks with no pending dependency and no files in common):
- Haiku → agent `implementer-fast`
- Sonnet → agent `implementer`
- Opus → agent `architect` produces the spec; then `implementer` implements
- Pass `effort` to the agent per the table's Effort column (R 0–1 → pass nothing).
  `max` only if the user asks.
- Each agent with `isolation: "worktree"`, branch `feat/<phase>-<slug>`; if the phase has
  a `Jira` field, use `feat/<KEY>-<slug>` (e.g. `feat/PROJ-124-login-form`).
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
diff only if something failed or looks wrong. On failure, send it back to the
same agent with the error (max 2 times). Still failing: raise **one** level — effort
first, and only then the model (effort is cheaper than switching models).

### 6. PRs
Use the `pr-create` skill on each green branch. In the PR, cite the phase and the task. Phase with
a `Jira` field → key at the start of the title (`PROJ-124 feat: ...`) and in the Context, so
Jira links the PR on its own. Do not write to Jira.

### 7. Report
Final table, one row per agent call (including planner, architect and retries):

| # | Task | Agent | Model | Effort | Attempt | Result | PR |

Flag downgrades (`sonnet + xhigh (was opus)`) and escalations (`effort high→xhigh`).
Then: totals per model (e.g. `haiku 3 · sonnet 5 · opus 1`) and what is still pending.
Update the plan by marking completed tasks (in its own `docs:` PR).
