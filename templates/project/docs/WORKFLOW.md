# Workflow — <Projeto>

Este projeto segue o fluxo do `agentic-workflows`. Cada etapa roda **numa sessão
separada**, termina num artefato (arquivo, PR, merge) e atualiza o **Estado** abaixo.
Perdido? Rode `/project-start` (sem argumento): ele lê este arquivo e diz o próximo comando.

## Estado

<!-- Atualizado por quem terminar uma etapa. Uma linha por etapa, data absoluta. -->
- Etapa atual: **0 — Setup**
- Fase do plano em andamento: —
- PRs abertos aguardando review/merge: —
- Última atualização: <AAAA-MM-DD>

## Setup (uma vez)

- [ ] 0. Ideia, stack e regras definidas — `/project-start "<ideia>"`
- [ ] 1. Esqueleto do app rodando e testes verdes na `main`
- [ ] 2. Plano em fases gravado em `docs/PLANO.md` — `/plan-create "<objetivo>"`

## Ciclo (repete por fase até o plano acabar)

```
 ┌─▶ 3. classificar a fase   /run-phase <n> --dry-run
 │   4. executar a fase       /run-phase <n>            → 1 PR por tarefa
 │   5. revisar cada PR       /pr-review <pr> e /code-review high --comment
 │   6. corrigir e mergear    humano: gh pr merge
 │   7. fechar a fase         marcar [x] no PLANO.md, atualizar Estado
 └── 8. próxima fase? volta ao 3.  Plano acabou? /plan-create para o próximo objetivo
```

| Se o Estado diz… | Rode |
|---|---|
| Setup incompleto | `/project-start` |
| Sem `docs/PLANO.md` | `/plan-create "<objetivo>"` |
| Fase N sem tarefas classificadas | `/run-phase N --dry-run` |
| Fase N classificada, sem PRs | `/run-phase N` |
| PRs abertos | `/pr-review <pr>` → ajustes → merge |
| Todos os PRs da fase mergeados | marcar fase `[x]`, seguir para N+1 |

## Regras do ciclo

- Uma etapa por sessão. Abriu sessão nova? Leia este arquivo primeiro.
- Nunca pule o `--dry-run`: é onde você corta tarefa grande ou modelo caro.
- Merge é sempre humano. Fase só fecha com todos os PRs mergeados e `main` verde.
- Mudou de ideia sobre o escopo? Volte ao `/plan-create`, não remende na execução.

## Histórico

<!-- AAAA-MM-DD — etapa — resultado (PR, commit, decisão) -->
