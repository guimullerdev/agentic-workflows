# Plano — agentic-workflows em inglês

> Objetivo: todo o texto do repositório em inglês, com plan-create, run-phase, project-start e pr-review funcionando de ponta a ponta, sem quebrar contratos entre arquivos.
> Fora de escopo: mudar comportamento das skills, reorganizar a estrutura, criar testes ou CI.

## Fase 1 — Caminho do plano e cabeçalhos do plan-template

- **Objetivo:** migrar juntos o contrato mais compartilhado: o caminho do plano e os cabeçalhos do plan-template.
- **Depende de:** —
- **Escopo:**
  - `docs/PLANO.md` → `docs/PLAN.md` em plan-create, jira-plan, project-start, `templates/project/CLAUDE.md` e `templates/project/docs/WORKFLOW.md`; run-phase procura `PLAN.md` primeiro e cai em `PLANO.md`.
  - Traduzir cabeçalhos e campos de `plan-template.md` (Phase N, Goal, Depends on, Scope, Out of scope, Likely files, Done criteria, Risk, Open questions, done) e atualizar no mesmo PR quem os lê: run-phase, `agents/phase-planner.md`, project-start, jira-plan.
  - phase-planner e run-phase aceitam cabeçalhos nos dois idiomas durante a transição.
- **Fora de escopo:** prosa das skills, README, flow.svg.
- **Arquivos prováveis:** `skills/{plan-create,run-phase,project-start,jira-plan}/**`, `agents/phase-planner.md`, `templates/project/**`
- **Critério de pronto:** `grep -rn "PLANO.md\|Critério de pronto\|Arquivos prováveis\|Depende de" skills agents templates` só encontra a linha do fallback e as de tolerância bilíngue; `/run-phase --dry-run` acha a próxima fase num plano com cabeçalhos antigos e noutro com cabeçalhos novos.
- **Risco:** um leitor esquecido lê a fase errado em silêncio. Depende das perguntas 1 e 4.
- [x] concluída

## Fase 2 — Contratos de WORKFLOW, review-rules e tabela de tarefas

- **Objetivo:** traduzir os demais formatos lidos pelas skills.
- **Depende de:** Fase 1
- **Escopo:**
  - Seções do WORKFLOW.md (State, Setup, Cycle, Cycle rules, History) e a tabela "If State says…", junto com project-start e o template CLAUDE.md.
  - Cabeçalhos de `templates/project/.claude/review-rules.md` e `templates/review-rules/*.md`, junto com pr-review, run-phase e project-skill-bootstrap.
  - Colunas da tabela de tarefas do run-phase e `output-contract.md`, incluindo a cópia em `docs/best-practices`.
- **Fora de escopo:** prosa fora desses cabeçalhos.
- **Arquivos prováveis:** `templates/**`, `skills/{project-start,pr-review,run-phase,project-skill-bootstrap}/**`, `docs/best-practices/output-contract.md`
- **Critério de pronto:** `grep -rn "Estado\|Histórico\|Regras do ciclo\|Se o Estado diz" skills templates` vazio; `diff` entre as duas cópias do output-contract vazio.
- **Risco:** projetos já inicializados têm WORKFLOW.md em português (pergunta 5).
- [x] concluída

## Fase 3 — Corpo das skills e dos agents

- **Objetivo:** instruções das skills e dos agents em inglês.
- **Depende de:** Fase 2
- **Escopo:**
  - Prosa dos 8 `SKILL.md` e dos arquivos de reference, um PR a cada 2–3 skills.
  - `agents/*.md` (5 arquivos), incluindo cabeçalhos de saída do pr-review e do pr-create.
  - Descriptions do frontmatter conforme a pergunta 2.
- **Fora de escopo:** docs, README, notes.
- **Arquivos prováveis:** `skills/*/SKILL.md`, `skills/*/reference/*`, `agents/*.md`
- **Critério de pronto:** `grep -rnwi "não\|você\|para o\|deve\|quando" skills agents` só retorna gatilhos bilíngues aprovados; `scripts/install.sh` roda sem erro.
- **Risco:** gatilhos só em inglês podem parar de disparar para quem escreve em português.
- [x] concluída

## Fase 4 — Docs, templates restantes e diagrama

- **Objetivo:** documentação para pessoas em inglês.
- **Depende de:** Fase 3
- **Escopo:**
  - `docs/best-practices/*.md`; `model-selection.md` mantém o nome (install.sh cria link para ele).
  - Texto do `docs/flow.svg`; renomear para `flow.svg` se a pergunta 3 aprovar, atualizando referências.
  - `notes/notebook-monitor.md` e prosa restante dos templates.
- **Fora de escopo:** README, ESTRUTURA.
- **Arquivos prováveis:** `docs/**`, `notes/**`, `templates/**`
- **Critério de pronto:** busca por palavras em português em `docs notes templates` vazia; SVG abre no navegador; link do install.sh resolve.
- **Risco:** texto em inglês mais longo pode quebrar o layout do SVG.
- [x] concluída

## Fase 5 — README, ESTRUTURA e varredura final

- **Objetivo:** fechar a tradução e remover o que era temporário.
- **Depende de:** Fase 4
- **Escopo:**
  - Traduzir `README.md`.
  - Destino do `ESTRUTURA.md` (fora do git): traduzir para `STRUCTURE.md` ou descartar.
  - Varredura do repositório; se a pergunta 1 decidir, remover o fallback `PLANO.md` e a tolerância bilíngue.
- **Fora de escopo:** novas funcionalidades.
- **Arquivos prováveis:** `README.md`, `ESTRUTURA.md`, `skills/run-phase/**`
- **Critério de pronto:** busca por palavras em português no repositório inteiro só retorna itens de uma lista de exceções documentada.
- **Risco:** remover o fallback quebra projetos que ainda têm `docs/PLANO.md`.
- [ ] concluída

## Perguntas em aberto

1. Renomear `PLANO.md` → `PLAN.md` mantendo `PLANO.md` como fallback? Por quanto tempo?
2. Manter gatilhos bilíngues (PT e EN) nas descriptions do frontmatter? **Decidido (2026-11-10): só inglês.**
3. Renomear `ESTRUTURA.md` → `STRUCTURE.md` e `fluxo.svg` → `flow.svg`? Versionar o ESTRUTURA.md? **Decidido (2026-11-10): renomeado para flow.svg.**
4. O plan-template fica em inglês de vez (phase-planner aceita os dois idiomas) ou o plano continua em português? **Decidido (2026-11-10): inglês de vez.**
5. WORKFLOW.md e PLANO.md antigos em projetos que já usam o kit: migrar, aceitar os dois formatos ou ignorar?
