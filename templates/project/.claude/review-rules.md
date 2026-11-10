# Review rules — <Project>

> Read by the global `pr-review` skill. Be specific and cite example files.

## Architecture
- `<layer A>` may import from `<layer B>`; never the other way around.
- Correct example: `<path/file>`

## Required patterns
- State: <e.g. server state via react-query; local UI state>. Example: `<file>`
- Fetch: <e.g. only inside hooks in `src/api/`>.
- Style: <e.g. Tailwind + tokens from `theme.ts`>.
- Naming: <components PascalCase, hooks `useX`, files ...>.

## Anti-patterns (blocking)
- <e.g. fetching directly inside a component>
- <e.g. backend business logic outside `services/`>

## Tests
- <what must be tested; where tests live; library>

## PR
- One topic per PR; < ~400 lines when possible.
- Description with context, how to test, and a link to the phase/issue.
