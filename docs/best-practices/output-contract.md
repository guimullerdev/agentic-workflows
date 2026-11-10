# Output contract

Every token a subagent returns enters the caller's context and is paid for again on
every following turn. This contract defines what agents and skills return.

## General rules

1. **Reference, not content.** Return paths (`file:line`), never pasted code, diffs
   or files. The caller reads what it needs.
2. **Summarized command output.** Tests, lint and build are reported as a count plus
   failures: `tests: 42 ok, 1 failed — auth.test.ts:88 expected 401 got 200`. No full logs.
3. **No narrative.** No "first I read…", no repeating the task, no polite closing.
4. **Cap.** A subagent's return fits in **~20 lines**. If it goes over, cut whatever
   the caller can get on its own (`git diff`, reading the file).
5. **Blockers come first.** If you stopped because of a doubt or an error, the first
   line says so.

## Standard block (agents that change code)

```
status: ok | falhou | bloqueado
files: path/a.ts, path/b.ts
tests: <N ok, M falharam> — <failures as file:line + 1 line of reason>
decisions: <only the non-obvious ones, 1 line each>   (omit if none)
risks/doubts: <1 line each>                           (omit if none)
```

Empty fields are omitted, not filled with "none".

## Per agent

| agent | returns | cap |
|---|---|---|
| implementer-fast | standard block without `decisions` | ~10 lines |
| implementer | standard block | ~20 lines |
| phase-planner | table + batches + questions (already defined in the agent) | the table |
| architect | the spec is the product: write it to a file when a destination exists and return the path + a 5-line summary | full spec only if there is no file |
| pr-reviewer | blockers, suggestions, questions — 1 item per line with `file:line` | no praise, no diff summary |

## Orchestrator side (run-phase and similar)

- Pass the subagent only what is needed: task, files, done criteria, test command and
  "return in the standard block". No raw JSON or conversation history.
- On receipt, check with `git diff --stat` and the test result; open the full diff
  only when something failed or looks wrong.
- To the user, one line per task: `✔/✖ T<#> <agent> (<model>) — <summary>`.

## Skills that talk to the user

Short final answer: what changed, where it is (link/path), what is left. Details only
when asked.
