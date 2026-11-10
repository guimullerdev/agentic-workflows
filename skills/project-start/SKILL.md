---
name: project-start
description: >-
  Starts a project from scratch with the agentic-workflows flow (idea → stack →
  skeleton → plan → phase cycle) and, when called without an argument in an
  existing project, reads docs/WORKFLOW.md and says which stage the project is
  at and what the next command is. Use when the user says "I'm going to create
  a new app", "start a project from scratch", "I don't know where to start",
  "where did I leave off?", "what's the next step?" or types /project-start.
argument-hint: "[\"<app idea in one sentence>\"] [--stack <stack>] [--no-scaffold]"
---

# project-start

Two modes:
- **With an idea** (empty or almost empty repo): runs Setup (stages 0–1 of `WORKFLOW.md`) and stops.
- **No argument** and `docs/WORKFLOW.md` exists: "where am I" mode (step 6).

Templates live in this repo under `templates/project/` (`CLAUDE.md`, `.claude/review-rules.md`,
`docs/WORKFLOW.md`) and `templates/review-rules/<stack>.md`. Find the path by following
this skill's symlink (`readlink -f ~/.claude/skills/project-start`).

## Non-negotiable rules
- Does not create the plan: that is `/plan-create`'s job, in another session. Does not implement features.
- One decision at a time, with a recommendation. Writes nothing before the user approves
  the project sheet from step 2.
- Never overwrites an existing file without showing the diff.

## Steps

### 1. Short interview (at most 5 questions, use AskUserQuestion)
- What the app does and for whom (observable result, not "a cool app").
- Platform: web, mobile, API, CLI, desktop.
- Stack: if the user has no preference, recommend **one** with a one-line reason
  (user default: React/Next on the front end, NestJS or Spring on the back end).
- Constraints: deadline, hosting, database, auth, budget.
- What stays **out** of v1.

### 2. Project sheet
Show in up to 15 lines: name, goal, stack, expected commands (dev/test/lint),
initial folder structure, out of scope and open questions. Wait for approval.

### 3. Skeleton (skip with `--no-scaffold`)
- `git init` if not a repo; branch `main`.
- Generate the skeleton with the stack's official generator (`create-next-app`, `nest new`,
  `spring init`, `npm create vite`…), not by hand. Ask for confirmation before running.
- Ensure a trivial passing test and a working test command.
- The stack's `.gitignore`.

### 4. Flow configuration
- `CLAUDE.md` from the template, filled in with the sheet (≤ 60 lines).
- `.claude/review-rules.md` from `templates/review-rules/<stack>.md`; with no
  template for the stack, start from `templates/project/.claude/review-rules.md`. Mark what is
  **inferred** — in a new project almost everything is; it will be refined with
  `/project-skill-bootstrap` once there is code.
- `docs/WORKFLOW.md` from the template: mark `[x]` on the completed stages 0 and 1,
  State = "Stage 2 — Plan", today's date, and one line in History.

### 5. Commit and delivery
- One commit `chore: bootstrap project with agentic workflow` on `main` (a new repo
  has no PR to review). Existing repo → branch `chore/bootstrap` and PR.
- End with exactly the next step, to run **in a new session**:
  `/plan-create "<goal from the sheet>"`.

### 6. "Where am I" mode (no argument)
- Read `docs/WORKFLOW.md`, `docs/PLAN.md` and `gh pr list --state open`.
  The `WORKFLOW.md` headers are English only (State, Cycle, Cycle rules, History, Setup).
  If they are in Portuguese, stop and tell the user to translate the headers first.
- Check the State against reality (phase marked without a merged PR, merged PR with
  an open phase…) and fix the State if it is outdated, showing the diff.
- Answer in 3 lines: current stage, what is missing to close it, next command
  (use the "If State says…" table from `WORKFLOW.md`).
- No `WORKFLOW.md` but with code: offer to create it from the template and run
  `/project-skill-bootstrap`.
