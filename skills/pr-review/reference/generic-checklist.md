# Generic review checklist

Use when there is no `.claude/review-rules.md`; covers the sections `Architecture`, `Required patterns`, `Anti-patterns (blocking)`, `Tests` and `PR`.

- [ ] The PR does one thing and the title describes it
- [ ] Names reveal intent; no obscure abbreviations
- [ ] Small functions, no hidden side effects
- [ ] Errors handled or propagated explicitly
- [ ] No dead code, console.log, or TODO without an issue
- [ ] Tests for the happy path and at least one error case
- [ ] No secrets, tokens or personal data
- [ ] New dependencies justified
- [ ] API/contract changes documented
- [ ] Front-end: keyboard accessible, labels, contrast, loading/error/empty states
