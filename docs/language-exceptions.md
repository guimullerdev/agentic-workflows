# Language exceptions

This repository is English-only. Every skill, agent, template, doc and note is written in English. The only Portuguese that remains is listed below, each with the reason it is legitimate. Anything the check finds that is not listed here is a bug: translate it.

## Reproduce the check

```sh
git grep -nIiE 'ção|ções|ões|ã|õ|ê|é|á|í|ó|ú|ç|\bfase\b|plano|não|você|arquivo|tarefa|concluída|objetivo|escopo' -- . ':!docs/language-exceptions.md'
```

This file is excluded because it has to quote the Portuguese words it documents. Line numbers below refer to the state when this list was written; match on the pattern if they drift.

## Allowed hits

### Legacy file name `PLANO.md` (migration notes)

| Location | Pattern | Why |
| --- | --- | --- |
| `README.md:~57` | `docs/PLANO.md` | Migration note: projects that still have the old plan must rename it to `docs/PLAN.md` and use English headers. The legacy name has to be spelled out. |
| `skills/run-phase/SKILL.md:~26` | `docs/PLANO.md` | Migration-stop sentence: when only the legacy plan (or Portuguese headers) is found, run-phase stops and tells the user to migrate. There is no fallback parsing. |

### Legacy Portuguese section titles (review-rules aliases)

| Location | Pattern | Why |
| --- | --- | --- |
| `skills/pr-review/SKILL.md:~19` | `Arquitetura`, `Patterns obrigatórios`, `Anti-patterns (bloqueantes)`, `Testes` | pr-review still maps the old Portuguese `review-rules.md` section titles to the English ones. The old titles must be quoted to be matched. |
| `skills/pr-review/reference/generic-checklist.md:~3` | same as above | Same alias mapping, repeated in the checklist. |
| `skills/project-start/SKILL.md:~69` | `Histórico`, `Se o Estado diz` | Maps old Portuguese WORKFLOW.md headings (`History`, `If State says…`) so legacy files are recognized. |

### The plan's own history

`docs/PLAN.md` records the translation project itself, so it quotes the Portuguese strings and the legacy name that earlier phases searched for and removed.

| Location | Pattern | Why |
| --- | --- | --- |
| `docs/PLAN.md:11` | `docs/PLANO.md` | Phase 1 scope: the rename being performed. |
| `docs/PLAN.md:16` | `PLANO.md`, `Critério de pronto`, `Arquivos prováveis`, `Depende de` | Phase 1 done criteria: the old strings searched for. |
| `docs/PLAN.md:30` | `Histórico`, `Regras do ciclo`, `Se o Estado diz` | Phase 2 done criteria: the old strings searched for. |
| `docs/PLAN.md:44` | `não`, `você`, `para o`, `deve`, `quando` | Phase 3 done criteria: the Portuguese words searched for. |
| `docs/PLAN.md:69`, `:73` | `PLANO.md` | Phase 5 scope and risk: the fallback that was removed. |
| `docs/PLAN.md:78`, `:82` | `PLANO.md` | Open questions 1 and 5: the legacy name under discussion. |

## Not Portuguese

Accented characters in proper names, quotations or symbols that are not Portuguese text are fine. At the time of writing none of these produce hits. If one appears (for example an author name such as "Müller"), add it here with its location.
