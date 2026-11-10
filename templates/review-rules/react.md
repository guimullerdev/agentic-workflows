# Review rules — <Project> (React / TypeScript)

> Copy to `<project>/.claude/review-rules.md` and adjust. Delete what does not apply.

## Architecture
- Organized by feature: `src/features/<feature>/{components,hooks,api,types}`; `src/shared/` for what is reused.
- A feature does not import an internal file from another feature — only from its public `index.ts` or from `shared`.
- UI components (`shared/ui`) know no business rules and do not call the API.
- Example of a correct feature: `<path>`

## Required patterns
- **Server data**: via <react-query/SWR/RTK Query> in `useX` hooks inside `api/`; never `fetch` inside a component.
- **State**: local by default; Context only for what is truly global (theme, auth). Global store: <zustand/redux> only in `<folder>`.
- Typed props, no `any`; API types in `types/`.
- A component that shows data also shows loading, empty, and error states.
- Logic (calculation, formatting, rules) in a pure function or testable hook, outside the JSX.
- Styling: <Tailwind/CSS Modules/styled> with theme tokens; no hardcoded colors or spacing.
- Names: components `PascalCase`, hooks `useCamelCase`, one exported component per file.

## Anti-patterns (blocking)
- `useEffect` to derive state from props/state (compute directly during render).
- `useEffect` with missing dependencies, or with the hooks lint rule disabled.
- `key` using the index in a list that reorders or filters.
- `useMemo`/`useCallback` without a measured reason (noise), or missing where it breaks a child's memo.
- Accessibility: clickable `div` without role/keyboard support, input without label, image without `alt`.
- `dangerouslySetInnerHTML` with unsanitized content.
- Secrets/keys in the bundle.

## Tests
- Testing Library: query by role/label/text, not by class or test-id when avoidable.
- Interaction with `user-event`; test visible behavior, not internal state.
- Hook with relevant logic: its own test. API calls mocked (MSW).

## PR
- One topic per PR; screenshot/GIF when the UI changes.
- Description: context, affected screens, how to test.
