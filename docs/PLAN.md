# Plan — agentic-workflows in English

> Goal: all repository text in English, with plan-create, run-phase, project-start and pr-review working end to end, without breaking contracts between files.
> Out of scope: changing skill behavior, reorganizing the structure, creating tests or CI.

## Phase 1 — Plan path and plan-template headers

- **Goal:** migrate the most shared contract together: the plan path and the plan-template headers.
- **Depends on:** —
- **Scope:**
  - `docs/PLANO.md` → `docs/PLAN.md` in plan-create, jira-plan, project-start, `templates/project/CLAUDE.md` and `templates/project/docs/WORKFLOW.md`; run-phase looks for `PLAN.md` first and falls back to `PLANO.md`.
  - Translate the headers and fields of `plan-template.md` (Phase N, Goal, Depends on, Scope, Out of scope, Likely files, Done criteria, Risk, Open questions, done) and update their readers in the same PR: run-phase, `agents/phase-planner.md`, project-start, jira-plan.
  - phase-planner and run-phase accept headers in both languages during the transition.
- **Out of scope:** skill prose, README, flow.svg.
- **Likely files:** `skills/{plan-create,run-phase,project-start,jira-plan}/**`, `agents/phase-planner.md`, `templates/project/**`
- **Done criteria:** `grep -rn "PLANO.md\|Critério de pronto\|Arquivos prováveis\|Depende de" skills agents templates` only finds the fallback line and the bilingual-tolerance lines; `/run-phase --dry-run` finds the next phase in a plan with old headers and in another with new headers.
- **Risk:** a forgotten reader silently reads the wrong phase. Depends on questions 1 and 4.
- [x] done

## Phase 2 — WORKFLOW, review-rules and task table contracts

- **Goal:** translate the remaining formats read by the skills.
- **Depends on:** Phase 1
- **Scope:**
  - WORKFLOW.md sections (State, Setup, Cycle, Cycle rules, History) and the "If State says…" table, together with project-start and the CLAUDE.md template.
  - Headers of `templates/project/.claude/review-rules.md` and `templates/review-rules/*.md`, together with pr-review, run-phase and project-skill-bootstrap.
  - Columns of the run-phase task table and `output-contract.md`, including the copy in `docs/best-practices`.
- **Out of scope:** prose outside those headers.
- **Likely files:** `templates/**`, `skills/{project-start,pr-review,run-phase,project-skill-bootstrap}/**`, `docs/best-practices/output-contract.md`
- **Done criteria:** `grep -rn "Estado\|Histórico\|Regras do ciclo\|Se o Estado diz" skills templates` empty; `diff` between the two copies of output-contract empty.
- **Risk:** already-initialized projects have a Portuguese WORKFLOW.md (question 5).
- [x] done

## Phase 3 — Skill and agent bodies

- **Goal:** skill and agent instructions in English.
- **Depends on:** Phase 2
- **Scope:**
  - Prose of the 8 `SKILL.md` files and the reference files, one PR per 2–3 skills.
  - `agents/*.md` (5 files), including the output headers of pr-review and pr-create.
  - Frontmatter descriptions per question 2.
- **Out of scope:** docs, README, notes.
- **Likely files:** `skills/*/SKILL.md`, `skills/*/reference/*`, `agents/*.md`
- **Done criteria:** `grep -rnwi "não\|você\|para o\|deve\|quando" skills agents` only returns approved bilingual triggers; `scripts/install.sh` runs without error.
- **Risk:** English-only triggers may stop firing for people who write in Portuguese.
- [x] done

## Phase 4 — Docs, remaining templates and diagram

- **Goal:** human-facing documentation in English.
- **Depends on:** Phase 3
- **Scope:**
  - `docs/best-practices/*.md`; `model-selection.md` keeps its name (install.sh links to it).
  - Text of `docs/flow.svg` (renamed from `fluxo.svg`), references updated.
  - `notes/notebook-monitor.md` and the remaining template prose.
- **Out of scope:** README, ESTRUTURA.
- **Likely files:** `docs/**`, `notes/**`, `templates/**`
- **Done criteria:** a search for Portuguese words in `docs notes templates` is empty; the SVG opens in a browser; the install.sh link resolves.
- **Risk:** longer English text may break the SVG layout.
- [x] done

## Phase 5 — README, STRUCTURE and final sweep

- **Goal:** finish the translation and remove what was temporary.
- **Depends on:** Phase 4
- **Scope:**
  - Translate `README.md`.
  - Fate of `ESTRUTURA.md` (outside git): translate to `STRUCTURE.md` or discard.
  - Repository sweep; if question 1 decides so, remove the `PLANO.md` fallback and the bilingual tolerance.
- **Out of scope:** new features.
- **Likely files:** `README.md`, `ESTRUTURA.md`, `skills/run-phase/**`
- **Done criteria:** a search for Portuguese words across the whole repository only returns items from a documented exception list (`docs/language-exceptions.md`).
- **Risk:** removing the fallback breaks projects that still have `docs/PLANO.md`.
- [x] done

## Open questions

1. Rename `PLANO.md` → `PLAN.md` keeping `PLANO.md` as a fallback? For how long? **Decided (2026-11-10): remove the `PLANO.md` fallback; old projects must rename their plan to `docs/PLAN.md`.**
2. Keep bilingual (PT and EN) triggers in the frontmatter descriptions? **Decided (2026-11-10): English only.**
3. Rename `ESTRUTURA.md` → `STRUCTURE.md` and `fluxo.svg` → `flow.svg`? Track ESTRUTURA.md in git? **Decided (2026-11-10): `fluxo.svg` renamed to `flow.svg` in Phase 4; `ESTRUTURA.md` translated to `STRUCTURE.md` and tracked in git.**
4. Does the plan-template stay in English for good (phase-planner accepts both languages), or does the plan stay in Portuguese? **Decided (2026-11-10): English for good.**
5. Old WORKFLOW.md and PLANO.md in projects already using the kit: migrate, accept both formats, or ignore? **Decided (2026-11-10): migrate; no old-format support.**
6. Where does the list of legitimate remaining Portuguese hits live? **Decided (2026-11-10): in `docs/language-exceptions.md`.**
