# Avaliação — notebook-monitor (nov/2026)

## O que já está bom
- Monorepo Yarn workspaces (`agent`, `backend`, `dashboard`, `shared`), CI rodando `yarn test`.
- `CONTRIBUTING.md` claro: 1 feature = 1 PR, TDD, Conventional Commits.
- `docs/PLANO.md` com MVP, v2 e "Fases" — base perfeita para `/run-phase`.
- Skill de projeto `.claude/skills/commit` (branch + PR, sem atribuição de IA, merge humano).

## Lacunas para o fluxo com agentes
1. **Sem `CLAUDE.md`** — agentes começam sem comandos/arquitetura. Gerar com `/project-skill-bootstrap`.
2. **Fases sem tarefas atômicas** — o PLANO descreve fases em prosa. Ideal: cada fase com
   lista de tarefas, arquivos e critério de pronto (o `phase-planner` faz isso no 1º uso;
   vale gravar o resultado no próprio PLANO).
3. **Sem `.claude/review-rules.md`** — definir limites: `shared` não importa de ninguém;
   `dashboard` só fala com `backend` via HTTP; `agent` não depende de `backend`.
4. **Testes só em `@nm/shared`** — `yarn test` raiz roda apenas um workspace. Para agentes
   em paralelo verificarem o próprio trabalho, cada pacote precisa de `test`.
5. **Sem lint/typecheck** — o reviewer gasta tokens em estilo. Adicionar ESLint/Prettier.
6. **Sem template de PR** (`.github/pull_request_template.md`).

## Sugestão de modelo por tipo de tarefa neste projeto
| Tarefa | Modelo |
|---|---|
| Novo campo no snapshot do agent + teste do diff | Haiku/Sonnet |
| Nova tela/componente no dashboard | Sonnet |
| Modelo de eventos v2 (snapshots → eventos), schema SQL | Opus → Sonnet |
| Tempo real (push ao locador) | Opus |
| Ajustes de docs/README/config CI | Haiku |
