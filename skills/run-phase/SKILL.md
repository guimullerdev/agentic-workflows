---
name: run-phase
description: >-
  Executa uma ou mais fases de um plano do projeto (docs/PLAN.md ou similar):
  quebra em tarefas, classifica cada uma por dificuldade e escolhe o modelo
  (haiku/sonnet/opus) e o effort, roda tarefas independentes em paralelo em worktrees e
  deixa um PR por tarefa. Use quando o usuário disser "roda a fase 1", "executa
  as fases 1 e 2", "implementa a próxima fase do plano" ou digitar /run-phase.
argument-hint: "<fase> [fase...] [--plan caminho] [--dry-run]"
---

# run-phase

## Regras inegociáveis
- Nunca commitar na `main`. Uma tarefa = uma branch = um PR.
- Nunca fazer merge. O merge é do usuário.
- Duas tarefas que tocam o mesmo arquivo **não** rodam em paralelo.
- Sem plano aprovado pelo usuário, nada é implementado.

## Passos

### 1. Localizar o plano
Procure, nesta ordem: `--plan`, `docs/PLAN.md`, `PLAN.md`, `docs/PLANO.md` (fallback legado), `ROADMAP.md`.

As fases podem estar em inglês ou nos cabeçalhos legados em português. Trate como equivalentes:
Phase N = Fase N; Goal = Objetivo; Jira = Jira; Depends on = Depende de; Scope = Escopo;
Out of scope = Fora de escopo; Likely files = Arquivos prováveis; Done criteria = Critério de pronto;
Risk = Risco; Open questions = Perguntas em aberto; checkbox `- [ ] done` = `- [ ] concluída` (e `[x]`).
A "próxima fase" é a primeira com checkbox desmarcado, em qualquer dos idiomas. Ao marcar
conclusão, use o mesmo idioma que o plano já usa.
Leia também `CLAUDE.md`, `CONTRIBUTING.md` e `.claude/review-rules.md` se existirem.

### 2. Planejar (subagent `phase-planner`)
Passe as fases pedidas e os arquivos acima, e diga se **opus está disponível**
(veja "Opus indisponível" abaixo). Ele devolve a tabela:

| # | Tarefa | Arquivos | Depende de | V | R | Modelo | Effort | Critério de pronto |

Pontuação, modelo e effort: veja `reference/model-selection.md` (cópia de
docs/best-practices/model-selection.md). Resumo: **V** (volume) escolhe o modelo,
**R** (raciocínio) escolhe o effort.

### 3. Confirmar com o usuário
Mostre a tabela e os "lotes" paralelos. Se `--dry-run`, pare aqui.
O usuário pode trocar o modelo e o effort de qualquer tarefa.

### 4. Executar por lotes
Para cada lote (tarefas sem dependência pendente e sem arquivos em comum):
- Haiku → agente `implementer-fast`
- Sonnet → agente `implementer`
- Opus → agente `architect` gera o spec; depois `implementer` implementa
- Passe `effort` ao agente conforme a coluna Effort da tabela (R 0–1 → não passe nada).
  `max` só se o usuário pedir.
- Cada agente com `isolation: "worktree"`, branch `feat/<fase>-<slug>`; se a fase tem
  campo `Jira`, use `feat/<KEY>-<slug>` (ex.: `feat/PROJ-124-login-form`).
- Prompt de cada agente: tarefa, arquivos, critério de pronto, comando de teste,
  "não toque em outros arquivos" e "retorne no bloco padrão" (contrato de saída em
  `reference/output-contract.md`). Não passe JSON bruto nem histórico da conversa.
- **Log de chamadas:** antes de cada chamada ao Agent, escreva uma linha visível
  `▶ T<#> <tarefa> → <agente> · <modelo> · effort <effort|padrão> · worktree <branch>`
  e, ao voltar, `✔/✖ T<#> <agente> (<modelo>) — <resumo em 1 linha>`. Vale também
  para `phase-planner`, `architect`, retries e escalonamentos. Guarde cada linha para
  o relatório final.

### 4b. Opus indisponível
A conta pode não ter opus no momento. Nunca rebaixe em silêncio:
- Os agents `phase-planner` e `architect` usam `model: inherit`. Sem opus, chame-os no
  modelo da sessão com `effort: xhigh`.
- Tarefa marcada opus na tabela → rode `sonnet` + `effort: xhigh` e mostre na tabela como
  `sonnet + xhigh (era opus)`.
- Diga ao usuário, em uma linha, quais tarefas foram rebaixadas, antes de executar. Ele
  pode preferir esperar por opus nas tarefas de risco alto (R ≥ 5).

### 5. Verificar
Para cada tarefa: rode os testes na worktree e confira `git diff --stat`; abra o diff
completo só se algo falhou ou parece errado. Falhou → devolva ao
mesmo agente com o erro (máx. 2 vezes). Ainda falhando: suba **um** nível — primeiro o
effort, e só depois o modelo (effort é mais barato que trocar de modelo).

### 6. PRs
Use a skill `pr-create` em cada branch verde. No PR, cite a fase e a tarefa. Fase com
campo `Jira` → chave no início do título (`PROJ-124 feat: ...`) e no Contexto, para o
Jira vincular o PR sozinho. Não escreva no Jira.

### 7. Relatório
Tabela final, uma linha por chamada de agente (inclusive planner, architect e retries):

| # | Tarefa | Agente | Modelo | Effort | Tentativa | Resultado | PR |

Marque rebaixamentos (`sonnet + xhigh (era opus)`) e escalonamentos (`effort high→xhigh`).
Depois: totais por modelo (ex.: `haiku 3 · sonnet 5 · opus 1`) e o que ficou pendente.
Atualize o plano marcando tarefas concluídas (em PR próprio `docs:`).
