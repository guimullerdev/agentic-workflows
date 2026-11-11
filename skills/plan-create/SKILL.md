---
name: plan-create
description: >-
  Creates or revises the project phase plan (docs/PLAN.md) from a goal: reads
  the repository, designs the phases with scope and done criteria, and writes
  them in the format the run-phase skill consumes. Use when the user says
  "create the plan for this project", "break this into phases", "build the
  roadmap", "I need a PLAN.md" or types /plan-create.
argument-hint: "<goal in one sentence> [--plan path] [--phases N] [--dry-run]"
---

# plan-create

Plans the project in **phases**. Planning a phase into **tasks** is done by the
`phase-planner`, via `/run-phase`. This skill is the previous step.

## Non-negotiable rules
- Implements nothing: no code edits, no branch, no PR.
- Does not write the plan until the user approves the phases.
- Does not invent requirements the user did not state and the code does not show.
  Anything assumed goes to "Open questions", not into the scope.
- An existing plan is never silently overwritten: see step 5.

## Steps

### 1. Understand the goal
If no argument was given, ask in one line what the project needs to deliver.
Vague goal ("improve the app") → ask for the expected observable result.

### 2. Survey the current state (`Explore` subagent, broad reading)
Ask the subagent, and do not read the repo yourself:
- Stack, framework, test and lint commands.
- Folder structure and layers; where the goal will touch.
- What of the goal **already exists** partially (avoids a duplicate phase).
- Rules already written: `CLAUDE.md`, `.claude/review-rules.md`, `CONTRIBUTING.md`, ADRs.

Do not start the app, Docker or a database.

### 3. Design the phases (`architect` subagent)
Opus when available; if not, call the `architect` on the session model with
`effort: xhigh` and tell the user in one line that the plan was made without opus.

Input: goal, findings from step 2, project rules, `--phases` if given.
Criteria for a good phase:
- Delivers value on its own and leaves `main` green.
- Fits in 1 to 5 small PRs. More than that → split into two phases.
- Depends at most on the previous phase. Cross dependency → reorder.
- Has a **verifiable** done criterion (command, test, observable behavior),
  never "working well".

Order by risk: whatever brings down the rest of the plan if wrong comes first.

### 4. Confirm with the user
Show the list of phases (number, goal, done criteria, dependency) and the open
questions. If `--dry-run`, stop here and do not write a file.
The user may cut, reorder or merge phases before writing.

### 5. Write
Destination: `--plan`, or `docs/PLAN.md`. Format: `reference/plan-template.md` —
this format is the contract with the `phase-planner`, do not improvise headers.
- File does not exist → create it.
- File exists → show the diff first. Phases already marked `[x]` are preserved
  as they are; new ones come after them, renumbered in sequence.
- `Plan: commit` (default, from the **Git conventions** in `CLAUDE.md`; see
  `../pr-create/reference/git-conventions.md`) → commit only the plan, `docs:`, on its own
  branch. The merge is the user's.
- `Plan: local` → write the file only: no commit, branch or PR; make sure `docs/PLAN.md` is
  listed in `.git/info/exclude`.

### 6. Deliver
Say in one line which phase is next and the command to classify it:
`/run-phase <n> --dry-run`.
