# agentic-workflows

Biblioteca pessoal de **skills, subagents, workflows e boas práticas** para Claude Code —
reaproveitável em projetos pessoais e no trabalho.

## Estrutura

```
skills/                  # skills globais (instaláveis em ~/.claude/skills)
  run-phase/             # executa fase(s) de um plano, escolhendo modelo por tarefa
  pr-create/             # abre PR padronizado (branch, conventional commits, descrição)
  pr-review/             # revisa PR contra padrões do projeto
  frontend-component/    # cria componente React com teste, a11y e padrões
  project-skill-bootstrap/  # gera skills específicas de um projeto (ex.: pr-review do projeto X)
agents/                  # subagents (instaláveis em ~/.claude/agents)
  phase-planner.md       # quebra uma fase em tarefas + atribui modelo
  implementer-fast.md    # haiku  — tarefas mecânicas
  implementer.md         # sonnet — feature padrão
  architect.md           # opus   — design, dados, decisões difíceis
  pr-reviewer.md         # revisão read-only
templates/project/       # esqueleto .claude/ para colar num projeto novo
templates/review-rules/  # regras de PR por stack: nestjs.md, spring.md, react.md
docs/best-practices/     # guias: skills, subagents, worktrees, seleção de modelo, workflows
notes/                   # avaliações de projetos (ex.: notebook-monitor)
scripts/install.sh       # symlink de skills/agents para ~/.claude
```

## Instalação

```bash
./scripts/install.sh            # global: ~/.claude/skills e ~/.claude/agents
./scripts/install.sh ../meu-app # num projeto: ../meu-app/.claude/
```

Symlinks: editou aqui, vale em todo lugar.

## Review por projeto

A skill `pr-review` é uma só; o que muda é `<projeto>/.claude/review-rules.md`.
Comece copiando o modelo da stack (`templates/review-rules/`) ou rode
`/project-skill-bootstrap` no projeto. O review é estático: lê regras + diff,
nunca sobe app, Docker ou banco.

## Fluxo principal

1. Projeto tem um `docs/PLANO.md` com fases.
2. `/run-phase 1 2` → o `phase-planner` lê as fases, quebra em tarefas e classifica
   cada uma (haiku / sonnet / opus).
3. Tarefas independentes rodam em paralelo, cada uma em **worktree** própria.
4. Cada tarefa termina com testes verdes → `/pr-create`.
5. `/pr-review <n>` antes do merge (o merge é sempre humano).

Leia [docs/best-practices/model-selection.md](docs/best-practices/model-selection.md) primeiro.
