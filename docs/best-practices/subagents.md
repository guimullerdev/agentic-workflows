# Best practices — Subagents

## What it is
A `.md` file in `~/.claude/agents/` or `<project>/.claude/agents/` with frontmatter.
It runs with **its own context** (does not pollute the main one) and returns only a report.

```yaml
---
name: implementer
description: Implements an already-specified task, with TDD. Use for standard features.
model: sonnet          # haiku | sonnet | opus | inherit
tools: Read, Edit, Write, Bash, Grep, Glob
---
<agent system prompt>
```

## When to use
- **Broad reading** (exploring the repo, finding usages) → cheap agent, returns the conclusion.
- **Independent tasks in parallel** → one agent per task, each in a worktree.
- **Review** with a "cold" eye (without the bias of whoever implemented it).

## When NOT to use
- Small task you would do in 3 tool calls.
- Tasks that depend on each other's results (run them in sequence).
- When it needs a lot of the conversation's context (the agent starts from scratch).

## Rules
1. **Self-sufficient prompt:** files, goal, done criterion, what NOT to touch.
2. **Ask for the return format** (e.g. "return: changed files, tests, risks").
3. **Restrict `tools`**: a reviewer does not need Edit.
4. **Model in the frontmatter** is how you pin Haiku/Sonnet/Opus per role.
5. **Never two agents writing the same files** — use worktrees.
6. Check the result (diff/tests); the agent's report is not proof.
