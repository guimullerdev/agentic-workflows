# Assessment — notebook-monitor (Nov/2026)

## What is already good
- Yarn workspaces monorepo (`agent`, `backend`, `dashboard`, `shared`), CI running `yarn test`.
- `CONTRIBUTING.md` is clear: 1 feature = 1 PR, TDD, Conventional Commits.
- `docs/PLAN.md` with MVP, v2 and "Phases" — a perfect base for `/run-phase`.
- Project skill `.claude/skills/commit` (branch + PR, no AI attribution, human merge).

## Gaps for the agent workflow
1. **No `CLAUDE.md`** — agents start without commands/architecture. Generate it with `/project-skill-bootstrap`.
2. **Phases without atomic tasks** — the PLAN describes phases in prose. Ideal: each phase with a
   list of tasks, files and a done criterion (the `phase-planner` does this on first use; it is worth saving the result in the PLAN itself).
3. **No `.claude/review-rules.md`** — define limits: `shared` does not import from anyone;
   `dashboard` only talks to `backend` via HTTP; `agent` does not depend on `backend`.
4. **Tests only in `@nm/shared`** — root `yarn test` runs only one workspace. For agents in parallel
   to verify their own work, each package needs a `test`.
5. **No lint/typecheck** — the reviewer spends tokens on style. Add ESLint/Prettier.
6. **No PR template** (`.github/pull_request_template.md`).

## Suggested model per task type in this project
| Task | Model |
|---|---|
| New field in the agent snapshot + diff test | Haiku/Sonnet |
| New screen/component in the dashboard | Sonnet |
| Event model v2 (snapshots → events), SQL schema | Opus → Sonnet |
| Real time (push to the locador) | Opus |
| Docs/README/CI config tweaks | Haiku |
