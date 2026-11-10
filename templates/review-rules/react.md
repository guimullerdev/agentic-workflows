# Review rules — <Project> (React / TypeScript)

> Copie para `<projeto>/.claude/review-rules.md` e ajuste. Apague o que não se aplica.

## Architecture
- Organização por feature: `src/features/<feature>/{components,hooks,api,types}`; `src/shared/` para o que é reutilizado.
- Feature não importa arquivo interno de outra feature — só do `index.ts` público dela ou de `shared`.
- Componentes de UI (`shared/ui`) não conhecem regra de negócio nem chamam API.
- Exemplo de feature correta: `<caminho>`

## Required patterns
- **Dados do servidor**: via <react-query/SWR/RTK Query> em hooks `useX` dentro de `api/`; nunca `fetch` dentro do componente.
- **Estado**: local por padrão; Context só para o que é realmente global (tema, auth). Store global: <zustand/redux> só em `<pasta>`.
- Props tipadas, sem `any`; tipos de API em `types/`.
- Componente com dados mostra loading, vazio e erro.
- Lógica (cálculo, formatação, regra) em função pura/hook testável, fora do JSX.
- Estilo: <Tailwind/CSS Modules/styled> com tokens do tema; sem cor/espaçamento hardcoded.
- Nomes: componentes `PascalCase`, hooks `useCamelCase`, um componente exportado por arquivo.

## Anti-patterns (blocking)
- `useEffect` para derivar estado de props/estado (calcular direto no render).
- `useEffect` com dependências faltando ou desabilitando o lint de hooks.
- `key` com índice em lista que reordena/filtra.
- `useMemo`/`useCallback` sem motivo medido (ruído) — ou faltando onde quebra memo de filho.
- Acessibilidade: `div` clicável sem role/teclado, input sem label, imagem sem `alt`.
- `dangerouslySetInnerHTML` com conteúdo não sanitizado.
- Segredos/chaves no bundle.

## Tests
- Testing Library: buscar por role/label/texto, não por classe ou test-id quando evitável.
- Interação com `user-event`; testar comportamento visível, não estado interno.
- Hook com lógica relevante: teste próprio. Chamadas de API mockadas (MSW).

## PR
- Um assunto por PR; screenshot/GIF quando muda UI.
- Descrição: contexto, telas afetadas, como testar.
