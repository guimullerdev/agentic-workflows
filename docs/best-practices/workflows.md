# Recommended workflows

## 1. Plan → phases → PRs (the main one)
```
docs/PLANO.md  ──/run-phase N──▶ phase-planner (opus)
                                   │ tasks + model + dependencies
                     ┌─────────────┼──────────────┐
              implementer-fast  implementer    architect→implementer
               (haiku, wt)      (sonnet, wt)    (opus spec, sonnet code)
                     └──── green tests ──── /pr-create ── /pr-review ── human merge
```

## 2. Front-end feature
1. `/frontend-component <Name>` — reads neighboring components, follows the pattern.
2. Test (Testing Library) before the implementation.
3. Check a11y and states (loading / empty / error).
4. `/pr-create`.

## 3. Reviewing someone else's PR (work)
1. `/pr-review 123` — reads the project's `.claude/review-rules.md`.
2. Output: blockers / suggestions / questions, with `file:line`.
3. You decide what to post (`--comment` only with your confirmation).

## 4. New project
1. Copy `templates/project/.claude` into the repo.
2. `/project-skill-bootstrap` — generates `review-rules.md` and `CLAUDE.md` from the code.
3. Commit `.claude/` to the repo so the team uses it too.

## Hygiene
- Keep `CLAUDE.md` short: commands, architecture in 10 lines, rules. No tutorials.
- Decisions live in `docs/` (ADR / PLANO), not in the conversation.
- Hooks (`settings.json`) for what **must** always happen (lint before commit).
