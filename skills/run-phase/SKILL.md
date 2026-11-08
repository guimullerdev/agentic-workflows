---
name: run-phase
description: >-
  Executa uma ou mais fases de um plano do projeto (docs/PLANO.md ou similar):
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
Procure, nesta ordem: `--plan`, `docs/PLANO.md`, `docs/PLAN.md`, `PLAN.md`, `ROADMAP.md`.
Leia também `CLAUDE.md`, `CONTRIBUTING.md` e `.claude/review-rules.md` se existirem.

### 2. Planejar (subagent `phase-planner`, opus)
Passe as fases pedidas e os arquivos acima. Ele devolve a tabela:

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
- Cada agente com `isolation: "worktree"`, branch `feat/<fase>-<slug>`.
- Prompt de cada agente: tarefa, arquivos, critério de pronto, comando de teste,
  "não toque em outros arquivos", formato de retorno.

### 5. Verificar
Para cada tarefa: rode os testes na worktree, confira o diff. Falhou → devolva ao
mesmo agente com o erro (máx. 2 vezes). Ainda falhando: suba **um** nível — primeiro o
effort, e só depois o modelo (effort é mais barato que trocar de modelo).

### 6. PRs
Use a skill `pr-create` em cada branch verde. No PR, cite a fase e a tarefa.

### 7. Relatório
Tabela final: tarefa, modelo e effort usados, PR, status, o que ficou pendente.
Atualize o plano marcando tarefas concluídas (em PR próprio `docs:`).
