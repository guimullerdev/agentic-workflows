---
name: project-skill-bootstrap
description: >-
  Analisa o repositório atual e gera a configuração .claude/ específica do
  projeto: CLAUDE.md, review-rules.md (padrões de arquitetura e PR) e, se
  pedido, skills próprias do projeto. Use quando o usuário disser "configura o
  claude nesse projeto", "cria uma skill de review pra esse projeto", "gera as
  regras de PR daqui" ou digitar /project-skill-bootstrap.
---

# project-skill-bootstrap

## 1. Levantar fatos (use um subagent Explore/haiku para leitura ampla)
- Stack, gerenciador de pacotes, comandos de dev/test/lint/build.
- Estrutura de pastas e camadas (ex.: `packages/*`, `src/features/*`).
- Padrões reais: estado, fetch, estilos, testes, nomes. Cite 1 arquivo exemplo de cada.
- Convenções de git: branches, commits, template de PR, CI.
- Regras já escritas: CONTRIBUTING, ADRs, lint configs.

## 2. Gerar (a partir de `templates/project/` deste repo)
- `CLAUDE.md` — ≤ 60 linhas: comandos, mapa da arquitetura, regras.
- `.claude/review-rules.md` — usado pela skill global `pr-review`:
  camadas e imports permitidos, patterns obrigatórios (com arquivo exemplo),
  anti-patterns, requisitos de teste, checklist de PR.
- Opcional: `.claude/skills/<nome>/SKILL.md` para fluxos só deste projeto.

## 3. Confirmar
Mostre as regras inferidas e marque o que é **inferido** vs **documentado**.
O usuário aprova antes de gravar. Não invente regra que o código não mostra.
