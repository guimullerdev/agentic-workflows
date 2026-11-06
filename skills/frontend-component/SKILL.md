---
name: frontend-component
description: >-
  Cria um componente de front-end (React/TSX ou JSX) seguindo os padrões já
  existentes no projeto, com teste, acessibilidade e estados de UI. Use quando o
  usuário pedir "cria um componente", "faz a tela X", "novo card/form/modal" ou
  digitar /frontend-component.
argument-hint: "<NomeDoComponente> [descrição]"
---

# frontend-component

## 1. Descobrir o padrão (não invente)
- Ache 2–3 componentes parecidos (`Glob "**/components/**"`). Copie: estrutura de
  pasta, export, estilo (CSS modules / Tailwind / styled), tipagem de props.
- Veja como o projeto faz estado (useState, context, zustand, redux) e fetch
  (react-query, SWR, fetch em hook). Siga o mesmo.
- Veja a lib de teste (Vitest/Jest + Testing Library).

## 2. Escolha de nível
- Visual puro, igual a outro existente → simples, sem estado.
- Com estado local / form → hook local, validação.
- Estado compartilhado / contexto / dados do servidor → **pare e proponha** o
  desenho (onde mora o estado, contrato de dados) antes de codar. Isso é tarefa
  de nível Opus em `run-phase`.

## 3. TDD
Escreva o teste antes: renderiza, interação principal (user-event), estados
loading / vazio / erro quando houver dados. Busque por role/label, não por classe.

## 4. Implementar
- Props mínimas e tipadas; sem `any`.
- Acessibilidade: elemento semântico, `label` em inputs, foco visível, teclado,
  `aria-*` só quando o HTML não resolve.
- Sem lógica de negócio no componente: extraia para hook/função pura testável.
- Sem `useEffect` para derivar estado; sem `useMemo/useCallback` sem motivo.

## 5. Fechar
Rode testes + lint + typecheck. Mostre arquivos criados e como usar o componente.
