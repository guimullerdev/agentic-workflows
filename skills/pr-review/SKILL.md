---
name: pr-review
description: >-
  Reviews a Pull Request (or the current diff) against the project's
  architecture, patterns and conventions. Use when the user asks for a PR
  review, "review this PR", "look at PR 123", "review my branch" or types
  /pr-review.
argument-hint: "[pr-number | branch] [--comment]"
allowed-tools: Bash(gh:*), Bash(git:*), Read, Grep, Glob
---

# pr-review

**Static** analysis: reads rules + diff + files. Never starts the app, Docker,
a database or a server, and does not need to understand the project's runtime —
only whether the code follows the defined patterns.

## 1. Load the project rules (in this order, all that exist)
1. `.claude/review-rules.md` — project-specific rules (main source). Sections: `Architecture`, `Required patterns`, `Anti-patterns (blocking)`, `Tests`, `PR`.
2. `CLAUDE.md`, `CONTRIBUTING.md`, `docs/adr/*`, `docs/architecture*`
3. Configs: eslint, tsconfig, prettier (what the tool already catches, do not comment on)
4. If nothing exists: use the stack template in `reference/stacks/`
   (`nestjs.md`, `spring.md`, `react.md`), or `reference/generic-checklist.md`, and
   warn that running `/project-skill-bootstrap` is worthwhile.

## 2. Get the diff
- PR: `gh pr view <n> --json title,body,files,baseRefName` and `gh pr diff <n>`
- Branch/local: `git diff <base>...HEAD`
Read whole files when the diff snippet is not enough to judge.

## 3. Review (in this priority)
1. **Correctness:** bugs, edge cases, async/race, null, swallowed errors.
2. **Architecture:** respects the layers/boundaries defined in the rules? Forbidden import?
3. **Project patterns:** names, folder structure, state, data fetching.
4. **Tests:** cover the new behavior? Does the test check behavior, not implementation?
5. **Front-end:** a11y, loading/empty/error states, re-render, keys, unnecessary memo.
6. **Security:** secrets, unvalidated input, XSS, personal data in logs.
7. Scope: does the PR mix concerns? Suggest splitting.

## 4. Output
```
## Summary
<1–3 lines + verdict: approve / approve with changes / request changes>

## Blockers
- `file:line` — problem — suggestion

## Suggestions
- ...

## Questions
- ...
```
Only flag what you confirmed by reading the code. No style issues the linter covers.

## 5. Post (only with `--comment` AND user confirmation)
`gh pr review <n> --comment --body-file <tmp>` — never `--approve` without an explicit request.
