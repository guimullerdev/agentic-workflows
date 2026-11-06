# Boas práticas — Subagents

## O que é
Arquivo `.md` em `~/.claude/agents/` ou `<projeto>/.claude/agents/` com frontmatter.
Roda com **contexto próprio** (não polui o principal) e devolve só um relatório.

```yaml
---
name: implementer
description: Implementa uma tarefa já especificada, com TDD. Use para features padrão.
model: sonnet          # haiku | sonnet | opus | inherit
tools: Read, Edit, Write, Bash, Grep, Glob
---
<system prompt do agente>
```

## Quando usar
- **Leitura ampla** (explorar repo, achar usos) → agente barato, devolve conclusão.
- **Tarefas independentes em paralelo** → um agente por tarefa, cada um em worktree.
- **Revisão** com olhar "frio" (sem o viés de quem implementou).

## Quando NÃO usar
- Tarefa pequena que você faria em 3 tool calls.
- Tarefas que dependem do resultado uma da outra (rode em sequência).
- Quando precisa de muito contexto da conversa (o agente começa do zero).

## Regras
1. **Prompt autossuficiente:** arquivos, objetivo, critério de pronto, o que NÃO tocar.
2. **Peça o formato do retorno** (ex.: "devolva: arquivos alterados, testes, riscos").
3. **Restrinja `tools`**: reviewer não precisa de Edit.
4. **Modelo no frontmatter** é o jeito de fixar Haiku/Sonnet/Opus por papel.
5. **Nunca dois agentes escrevendo os mesmos arquivos** — use worktrees.
6. Confira o resultado (diff/testes); o relatório do agente não é prova.
