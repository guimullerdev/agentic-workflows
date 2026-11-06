# Boas práticas — Skills

## O que é
Pasta com `SKILL.md` (frontmatter + instruções) e arquivos de apoio opcionais
(scripts, templates, referências). Fica em `~/.claude/skills/` (global) ou
`<projeto>/.claude/skills/` (projeto — versionada com o código).

## Frontmatter
```yaml
---
name: pr-review                 # = nome da pasta, kebab-case
description: >-                 # O MAIS IMPORTANTE: decide quando a skill dispara
  Revisa um PR contra os padrões deste projeto. Use quando o usuário pedir
  review, avaliação de PR, "olha esse PR", ou digitar /pr-review.
argument-hint: "<numero-do-pr>"
model: sonnet                   # opcional: força modelo
allowed-tools: Bash(gh:*), Read, Grep   # opcional: restringe ferramentas
disable-model-invocation: false # true = só roda via /comando
---
```

## Regras
1. **Description = gatilho.** Liste verbos e frases que o usuário realmente fala.
   Inclua o `/comando`. Escreva no idioma em que você pede.
2. **Uma skill, um trabalho.** `pr-create` e `pr-review` separadas.
3. **Passos numerados e verificáveis.** Cada passo com comando e critério de pronto.
4. **Regras inegociáveis no topo** (ex.: "nunca commitar na main").
5. **Progressive disclosure:** SKILL.md curto (< ~200 linhas); detalhes em
   `reference/*.md` que a skill manda ler só quando necessário.
6. **Scripts > prosa** para coisas determinísticas (checklists, lint, geração).
7. **Global vs projeto:** a lógica genérica fica global; o que é específico
   (arquitetura, padrões, comandos de teste) vai num skill de projeto ou num
   `reference/project.md` lido pela skill global.
8. **Teste a skill:** peça a tarefa de 3 jeitos diferentes e veja se dispara.
   Use `/skill-creator` para evals.

## Global + override de projeto (padrão recomendado)
A skill global `pr-review` procura, nesta ordem:
1. `.claude/review-rules.md` no projeto
2. `CLAUDE.md` / `CONTRIBUTING.md`
3. checklist genérico embutido

Assim você não duplica a skill: cada projeto só escreve suas regras.
