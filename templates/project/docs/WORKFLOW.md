# Workflow — <Project>

This project follows the `agentic-workflows` flow. Each stage runs in a **separate
session**, ends in an artifact (file, PR, merge) and updates the **State** below.
Lost? Run `/project-start` (no argument): it reads this file and tells you the next command.

## State

<!-- Updated by whoever finishes a stage. One line per stage, absolute date. -->
- Current stage: **0 — Setup**
- Plan phase in progress: —
- Open PRs awaiting review/merge: —
- Last updated: <YYYY-MM-DD>

## Setup (once)

- [ ] 0. Idea, stack and rules defined — `/project-start "<idea>"`
- [ ] 1. App skeleton running and tests green on `main`
- [ ] 2. Phased plan saved in `docs/PLAN.md` — `/plan-create "<goal>"`

## Cycle (repeats per phase until the plan is done)

```
 ┌─▶ 3. classify the phase    /run-phase <n> --dry-run
 │   4. run the phase         /run-phase <n>            → 1 PR per task/ticket
 │   5. review each PR        /pr-review <pr> and /code-review high --comment
 │   6. fix and merge         human: gh pr merge
 │   7. close the phase       mark [x] in PLAN.md, update State
 └── 8. next phase? back to 3.  Plan done? /plan-create for the next goal
```

| If State says… | Run |
|---|---|
| Setup incomplete | `/project-start` |
| No `docs/PLAN.md` | `/plan-create "<goal>"` |
| Phase N with no classified tasks | `/run-phase N --dry-run` |
| Phase N classified, no PRs | `/run-phase N` |
| Open PRs | `/pr-review <pr>` → fixes → merge |
| All PRs of the phase merged | mark phase `[x]`, move on to N+1 |

## Cycle rules

- One stage per session. Opened a new session? Read this file first.
- Never skip the `--dry-run`: it is where you cut a big task or an expensive model.
- Merge is always human. A phase only closes with all PRs merged and `main` green.
- Changed your mind about the scope? Go back to `/plan-create`, don't patch it during execution.

## History

<!-- YYYY-MM-DD — stage — result (PR, commit, decision) -->
