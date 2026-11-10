# Review rules — <Project> (NestJS)

> Copy to `<project>/.claude/review-rules.md` and adjust. Delete what does not apply.

## Architecture
- One module per domain: `src/<domain>/{<domain>.module,controller,service}.ts`, `dto/`, `entities/`.
- **Controller**: only receives the request, validates it (DTO), and calls the Service. No business rules, no database access.
- **Service**: business rules. Accesses data only via an injected Repository/ORM.
- **Repository/ORM** (TypeORM/Prisma): only inside the Service or in its own repository.
- A module only uses providers from another module if that module `exports` them. No importing internal paths of another domain.
- Example of a correct module: `src/<example>/`

## Required patterns
- Every input (body, query, params) has a DTO + `class-validator`; global `ValidationPipe`.
- Responses do not expose a raw entity with sensitive fields (password, tokens) — use an output DTO or `@Exclude`.
- Constructor injection (`constructor(private readonly x: XService)`); never `new XService()`.
- Errors use Nest HTTP exceptions (`NotFoundException`, `BadRequestException`...), not `throw new Error`.
- Config via `ConfigService`; never `process.env` scattered around the code.
- Async: always `await` or return promises; no dangling promises.
- Auth/permission via Guards and decorators, not `if` in the controller.
- Cross-cutting logic (logging, transformation) in Interceptors/Pipes, not duplicated.

## Anti-patterns (blocking)
- Controller importing Repository/PrismaClient.
- Endpoint without a validation DTO.
- Circular dependency between modules (`forwardRef` without justification).
- Secrets in code; `console.log` instead of the Logger.
- Query with concatenated string.

## Tests
- Service: unit test with mocked dependencies (`Test.createTestingModule`).
- New endpoint: e2e test (supertest) covering the happy path + 1 error.
- Test checks behavior, not internal calls.

## PR
- One topic per PR; migration together with the entity change.
- Description: context, affected endpoints, how to test.
