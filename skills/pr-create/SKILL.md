---
name: pr-create
description: >-
  Cria branch, commits em Conventional Commits, push e abre um Pull Request com
  descrição estruturada seguindo os padrões do projeto. Use quando o usuário
  pedir para abrir PR, "manda pra review", "sobe isso", "fecha essa mudança"
  ou digitar /pr-create.
argument-hint: "[titulo] [--draft] [--base main]"
allowed-tools: Bash(git:*), Bash(gh:*), Bash(yarn:*), Bash(npm:*), Bash(pnpm:*), Read, Grep
---

# pr-create

## Regras inegociáveis
- Nunca commitar/pushar direto na branch base.
- Nunca fazer merge, nunca `--force` sem pedido explícito.
- Sem atribuição de IA em commits, branch, título ou descrição (Co-Authored-By,
  "Generated with", etc.), salvo se o projeto pedir o contrário no CLAUDE.md.
- Testes verdes antes do push.

## Passos
1. `git status --short`, `git branch --show-current`. Se estiver na base, crie
   `feat|fix|chore|docs|refactor/<slug>`.
2. Descubra o comando de teste (`CLAUDE.md`, `CONTRIBUTING.md`, `package.json`) e rode.
   Vermelho → pare e reporte.
3. Commits: Conventional Commits, inglês, imperativo, ≤ 72 chars. Separe por
   assunto (ex.: `test:` e `feat:`) quando fizer sentido.
4. `git push -u origin <branch>`.
5. Se existir `.github/pull_request_template.md`, preencha-o. Senão use:

```markdown
## Contexto
<por quê; link para issue/fase do plano>

## O que mudou
- ...

## Como testar
1. ...

## Checklist
- [ ] Testes adicionados/atualizados
- [ ] Sem segredos / dados sensíveis
- [ ] Docs atualizadas (se aplicável)
```

6. `gh pr create --base <base> --title "<conventional title>" --body-file <tmp>` (`--draft` se pedido).
7. Devolva o link do PR. Não faça merge.
