# Best practices — Skills

## What it is
A folder with a `SKILL.md` (frontmatter + instructions) and optional support files
(scripts, templates, references). It lives in `~/.claude/skills/` (global) or
`<project>/.claude/skills/` (project — versioned with the code).

## Frontmatter
```yaml
---
name: pr-review                 # = folder name, kebab-case
description: >-                 # THE MOST IMPORTANT: decides when the skill triggers
  Reviews a PR against this project's standards. Use when the user asks for
  review, PR evaluation, "look at this PR", or types /pr-review.
argument-hint: "<pr-number>"
model: sonnet                   # optional: forces model
allowed-tools: Bash(gh:*), Read, Grep   # optional: restricts tools
disable-model-invocation: false # true = only runs via /command
---
```

## Rules
1. **Description = trigger.** List the verbs and phrases the user actually says.
   Include the `/command`. Write in the language you ask in.
2. **One skill, one job.** `pr-create` and `pr-review` stay separate.
3. **Numbered, verifiable steps.** Each step with a command and a done criterion.
4. **Non-negotiable rules at the top** (e.g. "never commit to main").
5. **Progressive disclosure:** SKILL.md stays short (< ~200 lines); details go in
   `reference/*.md` that the skill tells it to read only when needed.
6. **Scripts > prose** for deterministic things (checklists, lint, generation).
7. **Global vs project:** generic logic stays global; what is specific
   (architecture, standards, test commands) goes in a project skill or in a
   `reference/project.md` read by the global skill.
8. **Test the skill:** ask for the task in 3 different ways and see if it triggers.
   Use `/skill-creator` for evals.

## Global + project override (recommended pattern)
The global `pr-review` skill looks, in this order, for:
1. `.claude/review-rules.md` in the project
2. `CLAUDE.md` / `CONTRIBUTING.md`
3. a built-in generic checklist

That way you don't duplicate the skill: each project only writes its own rules.
