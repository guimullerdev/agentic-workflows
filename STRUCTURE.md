# Repository structure

This repository is a kit of **skills + subagents for Claude Code**. It organizes the work like this: idea → phased plan → execution by agents → PRs. Each task goes to the cheapest model that can handle it.

## Root
- **[README.md](README.md)**: overview of the kit, how to install it and how to use it. It also explains the dry-run and the call log of `run-phase`.
- **[.gitignore](.gitignore)**: ignores `.DS_Store` and the symlink `skills/run-phase/reference/model-selection.md`, which `install.sh` creates.

## `agents/` (subagents, each with a fixed model)
- **[phase-planner.md](agents/phase-planner.md)** (inherit): reads the phases of the plan and returns atomic tasks. Each task comes with dependencies, files, model and effort.
- **[architect.md](agents/architect.md)** (inherit, read-only): level 3 tasks, such as data model, global state, security or new architecture. Produces a spec that can be implemented.
- **[implementer.md](agents/implementer.md)** (sonnet): level 2. Standard features with TDD, or execution of a spec from the architect.
- **[implementer-fast.md](agents/implementer-fast.md)** (haiku): level 1. Mechanical tasks, such as boilerplate, renaming or obvious CRUD.
- **[pr-reviewer.md](agents/pr-reviewer.md)** (sonnet, read-only): reviews a diff and returns blockers, suggestions and questions with `file:line`.

## `skills/` (`/…` commands)
- **[project-start](skills/project-start/SKILL.md)**: starts a project from scratch, going through idea, stack, skeleton and plan. Without an argument, it reads `docs/WORKFLOW.md` and tells you which step you are on and the next command.
- **[plan-create](skills/plan-create/SKILL.md)**: creates or revises `docs/PLAN.md` in phases, each with a done criterion. Uses the [plan-template.md](skills/plan-create/reference/plan-template.md) as a model.
- **[jira-plan](skills/jira-plan/SKILL.md)**: same as `plan-create`, but starts from a Jira task and its subtasks. Puts the Jira key on each phase.
- **[run-phase](skills/run-phase/SKILL.md)**: the heart of the kit. It does the following:
  - breaks the phase into tasks with the `phase-planner`;
  - chooses the model and effort for each task;
  - runs in parallel, each task in a worktree;
  - opens one PR per task, or one per ticket when the project's `CLAUDE.md` sets `PR granularity: ticket`;
  - logs each agent call.
  Its [output-contract.md](skills/run-phase/reference/output-contract.md) limits the size of what the agents return.
- **[pr-create](skills/pr-create/SKILL.md)**: creates the branch, makes commits in Conventional Commits, pushes and opens the PR with a structured description.
- **[pr-review](skills/pr-review/SKILL.md)**: reviews a PR against the project rules. Uses the [generic-checklist.md](skills/pr-review/reference/generic-checklist.md) and `reference/stacks/`, which is a symlink to `templates/review-rules`.
- **[project-skill-bootstrap](skills/project-skill-bootstrap/SKILL.md)**: analyzes a repository and generates its `.claude/` (`CLAUDE.md`, `review-rules.md` and its own skills, if you ask for them). Also uses the `stacks` symlink.
- **[frontend-component](skills/frontend-component/SKILL.md)**: creates a React component following the project patterns, with tests, accessibility and UI states.

## `templates/`
- **`project/`**: skeleton that goes into a new project:
  - [CLAUDE.md](templates/project/CLAUDE.md): project commands and architecture;
  - [.claude/review-rules.md](templates/project/.claude/review-rules.md): review rules;
  - [docs/WORKFLOW.md](templates/project/docs/WORKFLOW.md): workflow state, which `project-start` reads.
- **`review-rules/`**: ready-made review rules per stack: [nestjs](templates/review-rules/nestjs.md), [react](templates/review-rules/react.md) and [spring](templates/review-rules/spring.md).

## `docs/`
- **[flow.svg](docs/flow.svg)**: flow diagram.
- **`best-practices/`**:
  - [model-selection.md](docs/best-practices/model-selection.md): table of level → model, with the rule "the cheapest one that gets it right the first time". `run-phase` uses this table.
  - [output-contract.md](docs/best-practices/output-contract.md): what agents and skills return, so as not to inflate the context of the caller.
  - [skills.md](docs/best-practices/skills.md) and [subagents.md](docs/best-practices/subagents.md): what they are and how to write them.
  - [workflows.md](docs/best-practices/workflows.md): the recommended workflows. The main one is plan → phases → PRs.
  - [worktrees.md](docs/best-practices/worktrees.md): how to use git worktree so several agents can work in parallel.

## Other
- **[scripts/install.sh](scripts/install.sh)**: creates symlinks of the skills and agents in `~/.claude`, or in `<project>/.claude` if you pass the path. It does not overwrite files that already exist and are not symlinks. It also links `model-selection.md` inside `run-phase`.
- **[notes/notebook-monitor.md](notes/notebook-monitor.md)**: evaluation of the notebook-monitor project for adopting this flow. Lists what is already good and the gaps, for example the lack of a `CLAUDE.md`.
