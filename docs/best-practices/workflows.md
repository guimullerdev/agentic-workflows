# Workflows recomendados

## 1. Plano → fases → PRs (o principal)
```
docs/PLANO.md  ──/run-phase N──▶ phase-planner (opus)
                                   │ tarefas + modelo + dependências
                     ┌─────────────┼──────────────┐
              implementer-fast  implementer    architect→implementer
               (haiku, wt)      (sonnet, wt)    (opus spec, sonnet code)
                     └──── testes verdes ──── /pr-create ── /pr-review ── merge humano
```

## 2. Feature front-end
1. `/frontend-component <Nome>` — lê componentes vizinhos, segue o padrão.
2. Teste (Testing Library) antes da implementação.
3. Checagem de a11y e estados (loading / vazio / erro).
4. `/pr-create`.

## 3. Review de PR de outra pessoa (trabalho)
1. `/pr-review 123` — lê `.claude/review-rules.md` do projeto.
2. Saída: bloqueantes / sugestões / perguntas, com `arquivo:linha`.
3. Você decide o que postar (`--comment` só com sua confirmação).

## 4. Novo projeto
1. Copie `templates/project/.claude` para o repo.
2. `/project-skill-bootstrap` — gera `review-rules.md` e `CLAUDE.md` a partir do código.
3. Commite `.claude/` no repo para o time usar também.

## Higiene
- `CLAUDE.md` curto: comandos, arquitetura em 10 linhas, regras. Nada de tutorial.
- Decisões ficam em `docs/` (ADR / PLANO), não na conversa.
- Hooks (`settings.json`) para o que **deve** acontecer sempre (lint antes de commit).
