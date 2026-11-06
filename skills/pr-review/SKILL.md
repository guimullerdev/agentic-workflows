---
name: pr-review
description: >-
  Revisa um Pull Request (ou o diff atual) contra os padrões de arquitetura,
  patterns e convenções do projeto. Use quando o usuário pedir review de PR,
  "avalia esse PR", "olha o PR 123", "revisa minha branch" ou digitar /pr-review.
argument-hint: "[numero-do-pr | branch] [--comment]"
allowed-tools: Bash(gh:*), Bash(git:*), Read, Grep, Glob
---

# pr-review

## 1. Carregar as regras do projeto (nesta ordem, todas que existirem)
1. `.claude/review-rules.md` — regras específicas (fonte principal)
2. `CLAUDE.md`, `CONTRIBUTING.md`, `docs/adr/*`, `docs/architecture*`
3. Configs: eslint, tsconfig, prettier (o que a ferramenta já pega, não comente)
4. Se nada existir: use `reference/generic-checklist.md` e avise o usuário que
   vale rodar `/project-skill-bootstrap`.

## 2. Obter o diff
- PR: `gh pr view <n> --json title,body,files,baseRefName` e `gh pr diff <n>`
- Branch/local: `git diff <base>...HEAD`
Leia os arquivos inteiros quando o trecho do diff não bastar para julgar.

## 3. Revisar (nesta prioridade)
1. **Correção:** bugs, casos de borda, async/race, null, erros engolidos.
2. **Arquitetura:** respeita camadas/limites definidos nas regras? Import proibido?
3. **Patterns do projeto:** nomes, estrutura de pastas, estado, data fetching.
4. **Testes:** cobre o comportamento novo? Teste testa comportamento, não implementação?
5. **Front-end:** a11y, estados loading/vazio/erro, re-render, keys, memo desnecessário.
6. **Segurança:** segredos, input não validado, XSS, dados pessoais em log.
7. Escopo: PR mistura assuntos? Sugira dividir.

## 4. Saída
```
## Resumo
<1–3 linhas + veredito: aprovar / aprovar com ajustes / pedir mudanças>

## Bloqueantes
- `arquivo:linha` — problema — sugestão

## Sugestões
- ...

## Perguntas
- ...
```
Só aponte o que você confirmou lendo o código. Nada de estilo que o linter cobre.

## 5. Postar (somente com `--comment` E confirmação do usuário)
`gh pr review <n> --comment --body-file <tmp>` — nunca `--approve` sem pedido explícito.
