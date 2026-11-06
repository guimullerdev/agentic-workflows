# Regras de review — <Projeto>

> Lido pela skill global `pr-review`. Seja específico e cite arquivos-exemplo.

## Arquitetura e camadas
- `<camada A>` pode importar de `<camada B>`; nunca o contrário.
- Exemplo correto: `<caminho/arquivo>`

## Patterns obrigatórios
- Estado: <ex.: server state via react-query; UI state local>. Exemplo: `<arquivo>`
- Fetch: <ex.: só dentro de hooks em `src/api/`>.
- Estilo: <ex.: Tailwind + tokens de `theme.ts`>.
- Nomes: <componentes PascalCase, hooks `useX`, arquivos ...>.

## Anti-patterns (bloqueantes)
- <ex.: fetch direto dentro de componente>
- <ex.: lógica de negócio no backend fora de `services/`>

## Testes
- <o que é obrigatório testar; onde ficam; lib>

## PR
- Um assunto por PR; < ~400 linhas quando possível.
- Descrição com contexto, como testar e link da fase/issue.
