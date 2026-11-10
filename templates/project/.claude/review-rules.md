# Review rules — <Project>

> Lido pela skill global `pr-review`. Seja específico e cite arquivos-exemplo.

## Architecture
- `<camada A>` pode importar de `<camada B>`; nunca o contrário.
- Exemplo correto: `<caminho/arquivo>`

## Required patterns
- Estado: <ex.: server state via react-query; UI state local>. Exemplo: `<arquivo>`
- Fetch: <ex.: só dentro de hooks em `src/api/`>.
- Estilo: <ex.: Tailwind + tokens de `theme.ts`>.
- Nomes: <componentes PascalCase, hooks `useX`, arquivos ...>.

## Anti-patterns (blocking)
- <ex.: fetch direto dentro de componente>
- <ex.: lógica de negócio no backend fora de `services/`>

## Tests
- <o que é obrigatório testar; onde ficam; lib>

## PR
- Um assunto por PR; < ~400 linhas quando possível.
- Descrição com contexto, como testar e link da fase/issue.
