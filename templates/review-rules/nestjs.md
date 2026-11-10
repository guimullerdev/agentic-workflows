# Review rules — <Project> (NestJS)

> Copie para `<projeto>/.claude/review-rules.md` e ajuste. Apague o que não se aplica.

## Architecture
- Um módulo por domínio: `src/<dominio>/{<dominio>.module,controller,service}.ts`, `dto/`, `entities/`.
- **Controller**: só recebe request, valida (DTO) e chama o Service. Sem regra de negócio, sem acesso a banco.
- **Service**: regra de negócio. Acessa dados só via Repository/ORM injetado.
- **Repository/ORM** (TypeORM/Prisma): só dentro do Service ou de um repository próprio.
- Módulo só usa providers de outro módulo se este os `exports`. Sem import de caminho interno de outro domínio.
- Exemplo de módulo correto: `src/<exemplo>/`

## Required patterns
- Toda entrada (body, query, params) com DTO + `class-validator`; `ValidationPipe` global.
- Resposta não expõe entidade crua com campos sensíveis (senha, tokens) — usar DTO de saída ou `@Exclude`.
- Injeção por construtor (`constructor(private readonly x: XService)`); nunca `new XService()`.
- Erros com exceções HTTP do Nest (`NotFoundException`, `BadRequestException`...), não `throw new Error`.
- Config via `ConfigService`; nunca `process.env` espalhado.
- Async: sempre `await`/retornar promises; nada de promise solta.
- Auth/permissão via Guards e decorators, não `if` no controller.
- Lógica transversal (log, transformação) em Interceptors/Pipes, não duplicada.

## Anti-patterns (blocking)
- Controller importando Repository/PrismaClient.
- Endpoint sem DTO de validação.
- Dependência circular entre módulos (`forwardRef` sem justificativa).
- Segredos em código; `console.log` em vez do Logger.
- Query com string concatenada.

## Tests
- Service: teste unitário com dependências mockadas (`Test.createTestingModule`).
- Endpoint novo: teste e2e (supertest) do caminho feliz + 1 erro.
- Teste testa comportamento, não chamadas internas.

## PR
- Um assunto por PR; migration junto com a mudança de entidade.
- Descrição: contexto, endpoints afetados, como testar.
