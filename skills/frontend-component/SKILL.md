---
name: frontend-component
description: >-
  Creates a front-end component (React/TSX or JSX) following the patterns already
  in the project, with tests, accessibility and UI states. Use when the user asks
  for "create a component", "build the X screen", "new card/form/modal", or types
  /frontend-component.
argument-hint: "<ComponentName> [description]"
---

# frontend-component

## 1. Find the pattern (don't invent)
- Find 2–3 similar components (`Glob "**/components/**"`). Copy: folder structure,
  export, style (CSS modules / Tailwind / styled), props typing.
- See how the project handles state (useState, context, zustand, redux) and fetching
  (react-query, SWR, fetch in a hook). Follow the same approach.
- Check the test library (Vitest/Jest + Testing Library).

## 2. Choose the level
- Pure visual, same as an existing one → simple, no state.
- With local state / form → local hook, validation.
- Shared state / context / server data → **stop and propose** the design (where the
  state lives, data contract) before coding. This is Opus-level work in `run-phase`.

## 3. TDD
Write the test first: renders, main interaction (user-event), loading / empty / error
states when there is data. Query by role/label, not by class.

## 4. Implement
- Minimal, typed props; no `any`.
- Accessibility: semantic element, `label` on inputs, visible focus, keyboard support,
  `aria-*` only when HTML alone does not solve it.
- No business logic in the component: extract it to a testable hook/pure function.
- No `useEffect` to derive state; no `useMemo/useCallback` without a reason.

## 5. Wrap up
Run tests + lint + typecheck. Show the created files and how to use the component.
