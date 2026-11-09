# agentic-workflows

Biblioteca pessoal de **skills, subagents, workflows e boas práticas** para Claude Code,
reaproveitável em projetos pessoais e no trabalho.

A ideia: você pensa o projeto e aprova as decisões; os agentes quebram as fases em
tarefas, escolhem o modelo de cada uma, implementam em paralelo e abrem os PRs. O merge
é sempre seu.

## Instalação

```bash
./scripts/install.sh            # global: ~/.claude/skills e ~/.claude/agents
./scripts/install.sh ../meu-app # num projeto: ../meu-app/.claude/
```

Symlinks: editou aqui, vale em todo lugar.

- **Prefira o global.** A instalação por projeto cria symlinks absolutos para esta máquina;
  se o `.claude/` do app for commitado, eles quebram para outras pessoas e no CI.
- **Skill ou agent novo exige rodar o script de novo.** O link só é criado quando o script
  roda; editar algo que já existe não precisa.

## Uso rápido

**Projeto novo**, na pasta do app:

```text
/project-start "<ideia em uma frase>"   # entrevista, stack, esqueleto, CLAUDE.md, review-rules.md, docs/WORKFLOW.md
/plan-create "<objetivo>" --dry-run     # vê as fases sem gravar
/plan-create "<objetivo>"               # grava docs/PLANO.md
/run-phase 1 --dry-run                  # vê tarefas, modelo e effort de cada uma
/run-phase 1                            # executa: 1 worktree e 1 PR por tarefa
```

**Projeto que já tem código:** troque o primeiro passo por `/project-skill-bootstrap`
(gera `CLAUDE.md` e `review-rules.md` a partir do repositório).

**A partir de uma task do Jira:** troque o `/plan-create` por `/jira-plan`. Ele lê a
task e as subtasks e grava o mesmo `docs/PLANO.md`, com a chave do Jira em cada fase:

```text
/jira-plan PROJ-123 --dry-run   # vê o mapeamento subtask → fase sem gravar
/jira-plan PROJ-123             # grava docs/PLANO.md
/run-phase 1 --dry-run          # daqui em diante, igual
/run-phase 1                    # branch feat/PROJ-124-<slug>, PR com a chave no título
```

Precisa do Atlassian MCP conectado (ou `acli`/`jira` CLI autenticada). A skill só
**lê** o Jira; escrever lá (comentário, transição) só com pedido seu e confirmação.

**Perdido?** `/project-start` sem argumento lê `docs/WORKFLOW.md` e diz em que etapa você
está e qual o próximo comando. Rode cada etapa numa sessão nova para não arrastar contexto.

## Fluxo completo

![Fluxo do projeto ao merge](docs/fluxo.svg)

| # | Etapa | Comando | Quem executa |
|---|-------|---------|--------------|
| 1 | Pensar o projeto: contexto, stack, regras de review | `/project-start` (do zero) ou `/project-skill-bootstrap` (código existente) | skill |
| 2 | Revisar as fases propostas, sem gravar nada | `/plan-create "<objetivo>" --dry-run` | `architect` (opus\*) |
| 3 | Gravar `docs/PLANO.md` | `/plan-create "<objetivo>"` ou `/jira-plan <KEY>` | `architect` (opus\*) |
| 4 | Quebrar a fase em tarefas e escolher modelo + effort, sem executar | `/run-phase <fase> --dry-run` | `phase-planner` (opus\*) |
| 5 | Executar a fase em lotes paralelos, 1 worktree por tarefa | `/run-phase <fase>` | `implementer-fast` / `implementer` / `architect` |
| 6 | Abrir um PR por tarefa (1 tarefa = 1 branch = 1 PR) | `/pr-create` | skill (chamada pelo `run-phase`) |
| 7 | Revisar contra `.claude/review-rules.md` e caçar bugs | `/pr-review <n>`, `/code-review high --comment` | `pr-reviewer` + review nativo |
| 8 | Merge e marcar a fase como concluída no plano | `gh pr merge` | sempre humano |

Antes de rodar uma fase, resolva as **perguntas em aberto** do plano que a afetam;
senão o agente trava ou decide sozinho.

### O que o `--dry-run` faz

Mostra o resultado **sem efeito colateral**, para você revisar antes de gastar tokens:

- **`/plan-create --dry-run`**: exibe as fases e as perguntas em aberto; **não grava**
  o `PLANO.md`.
- **`/run-phase <fase> --dry-run`**: exibe a tabela de tarefas e os lotes paralelos;
  **não cria** worktree, não escreve código, não abre PR.

```text
| # | Tarefa | Arquivos | Depende de | V | R | Modelo | Effort | Critério de pronto |
```

Não gostou de um modelo ou effort? Peça a troca e rode sem a flag.

Sem a flag, o `run-phase` mostra cada chamada de agente enquanto roda e termina com um
relatório de todas elas (inclusive planner, architect e novas tentativas), com o total
por modelo:

```text
▶ T2 login form → implementer · sonnet · effort high · worktree feat/PROJ-124-login-form
✔ T2 implementer (sonnet) — form + testes passando

| # | Tarefa | Agente | Modelo | Effort | Tentativa | Resultado | PR |
haiku 3 · sonnet 5 · opus 1
```

### Onde fica o modelo de cada tarefa

**Não fica no `PLANO.md`**, de propósito. O plano descreve só fases (objetivo, escopo,
critério de pronto). O modelo depende de como a fase é quebrada em tarefas, e quem faz
isso é o `run-phase`, na hora de rodar, via `phase-planner`. Uma mesma fase pode ter uma
tarefa para haiku e outra para opus.

A pontuação usa dois eixos:

- **Volume (V)** escolhe o modelo: 0–2 haiku → `implementer-fast`; 3–5 sonnet →
  `implementer`; 6+ opus → `architect` gera o spec e `implementer` implementa.
- **Raciocínio (R)** escolhe o effort: `medium` → `xhigh`.

Detalhes em [docs/best-practices/model-selection.md](docs/best-practices/model-selection.md).
Formato de retorno dos agentes (o que cada um devolve, com teto de linhas) em
[docs/best-practices/output-contract.md](docs/best-practices/output-contract.md).

\* `architect` e `phase-planner` usam `model: inherit`: pedem opus quando a conta tem e
caem em `sonnet` + `effort: xhigh` quando não, sempre avisando qual tarefa foi rebaixada.

## Review por projeto

A skill `pr-review` é uma só; o que muda é `<projeto>/.claude/review-rules.md`.
Comece copiando o modelo da stack (`templates/review-rules/`) ou rode
`/project-skill-bootstrap` no projeto. O review é estático: lê regras + diff,
nunca sobe app, Docker ou banco.

## Estrutura

```
skills/                  # skills globais (instaláveis em ~/.claude/skills)
  project-start/         # começa um app do zero com o fluxo; sem argumento diz "onde estou"
  plan-create/           # cria docs/PLANO.md em fases, no formato que run-phase consome
  jira-plan/             # idem, a partir de uma task do Jira + subtasks
  run-phase/             # executa fase(s) de um plano, escolhendo modelo e effort por tarefa
  pr-create/             # abre PR padronizado (branch, conventional commits, descrição)
  pr-review/             # revisa PR contra padrões do projeto
  frontend-component/    # cria componente React com teste, a11y e padrões
  project-skill-bootstrap/  # gera CLAUDE.md, review-rules.md e skills próprias de um projeto
agents/                  # subagents (instaláveis em ~/.claude/agents)
  phase-planner.md       # opus*  — quebra uma fase em tarefas + atribui modelo/effort
  implementer-fast.md    # haiku  — tarefas mecânicas
  implementer.md         # sonnet — feature padrão
  architect.md           # opus*  — design, dados, decisões difíceis
  pr-reviewer.md         # revisão read-only
templates/project/       # esqueleto .claude/ + docs/WORKFLOW.md (estado e ciclo) para projeto novo
templates/review-rules/  # regras de PR por stack: nestjs.md, spring.md, react.md
docs/fluxo.svg           # diagrama do fluxo (usado acima)
docs/best-practices/     # guias: skills, subagents, worktrees, seleção de modelo, workflows
notes/                   # avaliações de projetos (ex.: notebook-monitor)
scripts/install.sh       # symlink de skills/agents para ~/.claude
```

## Estado e lacunas conhecidas

- **Fluxo ainda não validado de ponta a ponta.** Cada peça funciona isolada; para testar,
  rode o [Uso rápido](#uso-rápido) num app descartável.
- **A decisão do `--dry-run` não é persistida.** A tabela de modelos existe só no chat;
  uma flag `--annotate` deveria gravar modelo e lotes dentro da fase no `PLANO.md`.
- **Passo 7 tem dois reviews sem ordem definida.** `/pr-review` (padrões do projeto) e
  `/code-review` (bugs de correção) são complementares, mas a ordem não está documentada
  dentro da skill.
- **O plano é marcado cedo.** O `run-phase` marca tarefas concluídas na abertura do PR,
  não no merge; falta um gatilho pós-merge.
