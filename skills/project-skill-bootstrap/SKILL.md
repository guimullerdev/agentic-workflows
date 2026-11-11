---
name: project-skill-bootstrap
description: >-
  Analyzes the current repository and generates the project-specific .claude/
  configuration: CLAUDE.md, review-rules.md (architecture and PR patterns) and,
  if requested, project-own skills. Use when the user says "set up claude in
  this project", "create a review skill for this project", "generate the PR
  rules here" or types /project-skill-bootstrap.
---

# project-skill-bootstrap

## 1. Gather facts (use an Explore/haiku subagent for broad reading)
- Stack and framework (NestJS, Spring, React...), test and lint commands.
- Folder structure and layers (e.g. `packages/*`, `src/features/*`).
- Real patterns: state, fetch, styles, tests, naming. Cite 1 example file for each.
- Git conventions: branches, commits, PR template, CI. Look at the real branch names
  (`git branch -r --sort=-committerdate | head -30`) and recent merged PRs
  (`gh pr list --state merged --limit 20 --json title,headRefName`) to infer the `Branch`
  and `PR title` patterns and whether PRs map one-to-one to Jira keys (`PR granularity: ticket`).
- Rules already written: CONTRIBUTING, ADRs, lint configs.

Do not start the app, Docker or a database: the goal is the code's patterns.

## 2. Generate (from `templates/` in this repo)
- Start from the stack template in `reference/stacks/<stack>.md` (nestjs, spring, react) and adjust it to what
  the code actually does.
- `CLAUDE.md` — ≤ 60 lines: commands, architecture map, rules, and the **Git conventions**
  section (`PR granularity`, `Branch`, `PR title`, `Plan`) in the format of
  `../pr-create/reference/git-conventions.md`. Only lines the repo shows evidence for; the
  rest stay out and use the defaults.
- `.claude/review-rules.md` — used by the global `pr-review` skill:
  layers and allowed imports, required patterns (with an example file),
  anti-patterns, test requirements, PR checklist. Use the English headings from the template:
  `Architecture`, `Required patterns`, `Anti-patterns (blocking)`, `Tests`, `PR`.
  When updating an existing file with legacy Portuguese headings, keep the content and migrate the headings.
- Optional: `.claude/skills/<name>/SKILL.md` for flows specific to this project.

## 3. Confirm
Show the inferred rules and mark what is **inferred** vs **documented**.
The user approves before writing. Do not invent a rule the code does not show.
