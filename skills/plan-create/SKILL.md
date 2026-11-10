---
name: plan-create
description: >-
  Cria ou revisa o plano de fases do projeto (docs/PLAN.md) a partir de um
  objetivo: lê o repositório, desenha as fases com escopo e critério de pronto e
  grava no formato que a skill run-phase consome. Use quando o usuário disser
  "cria o plano desse projeto", "quebra isso em fases", "monta o roadmap",
  "preciso de um PLAN.md" ou digitar /plan-create.
argument-hint: "<objetivo em uma frase> [--plan caminho] [--phases N] [--dry-run]"
---

# plan-create

Planeja o projeto em **fases**. Quem planeja a fase em **tarefas** é o
`phase-planner`, via `/run-phase`. Esta skill é a etapa anterior.

## Regras inegociáveis
- Não implementa nada: nenhuma edição de código, nenhuma branch, nenhum PR.
- Não grava o plano sem o usuário aprovar as fases.
- Não inventa requisito que o usuário não disse nem o código mostra. O que for
  suposição vai para "Open questions", não para o escopo.
- Plano existente nunca é sobrescrito em silêncio: veja o passo 5.

## Passos

### 1. Entender o objetivo
Se o argumento não veio, pergunte em uma linha o que o projeto precisa entregar.
Objetivo vago ("melhorar o app") → peça o resultado observável esperado.

### 2. Levantar o estado atual (subagent `Explore`, leitura ampla)
Peça ao subagent, e não leia o repo você mesmo:
- Stack, framework, comandos de teste e lint.
- Estrutura de pastas e camadas; onde o objetivo vai encostar.
- O que do objetivo **já existe** parcialmente (evita fase duplicada).
- Regras já escritas: `CLAUDE.md`, `.claude/review-rules.md`, `CONTRIBUTING.md`, ADRs.

Não suba app, Docker ou banco.

### 3. Desenhar as fases (subagent `architect`)
Opus quando disponível; se não estiver, chame o `architect` no modelo da sessão com
`effort: xhigh` e avise o usuário em uma linha de que o plano saiu sem opus.

Entrada: objetivo, achados do passo 2, regras do projeto, `--phases` se dado.
Critérios de uma fase boa:
- Entrega valor sozinha e deixa a `main` verde.
- Cabe em 1 a 5 PRs pequenos. Mais que isso → quebre em duas fases.
- Depende no máximo da fase anterior. Dependência cruzada → reordene.
- Tem critério de pronto **verificável** (comando, teste, comportamento observável),
  nunca "funcionando bem".

Ordene por risco: o que derruba o resto do plano se estiver errado vem primeiro.

### 4. Confirmar com o usuário
Mostre a lista de fases (número, objetivo, critério de pronto, dependência) e as
perguntas em aberto. Se `--dry-run`, pare aqui e não escreva arquivo.
O usuário pode cortar, reordenar ou fundir fases antes de gravar.

### 5. Gravar
Destino: `--plan`, ou `docs/PLAN.md`. Formato: `reference/plan-template.md` —
esse formato é o contrato com o `phase-planner`, não improvise cabeçalho.
- Arquivo não existe → cria.
- Arquivo existe → mostre o diff antes. Fases já marcadas `[x]` são preservadas
  como estão; as novas entram depois delas, renumeradas em sequência.
- Commit só do plano, `docs:`, em branch própria. O merge é do usuário.

### 6. Entregar
Diga em uma linha qual é a próxima fase e o comando para classificá-la:
`/run-phase <n> --dry-run`.
