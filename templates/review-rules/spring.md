# Review rules — <Project> (Java / Spring Boot)

> Copy to `<project>/.claude/review-rules.md` and adjust. Delete what does not apply.

## Architecture
- Layers: `controller` → `service` → `repository`. Never skip a layer or invert the direction.
  (If the project uses hexagonal/clean: `adapter.in` → `application/usecase` → `domain` ← `adapter.out`;
  `domain` does not import Spring or JPA.)
- Package by feature: `com.<company>.<app>.<feature>.{controller,service,repository,dto,domain}`.
- Example of a correct feature: `<path>`

## Required patterns
- **Controller**: receives/validates (`@Valid` + Bean Validation on the DTO), calls the service, returns `ResponseEntity`/DTO. No business rules.
- **DTO separate from the entity**: never expose `@Entity` in the API. Map with MapStruct or an explicit mapper. Prefer `record` for DTOs.
- **Constructor injection** (`final` fields; Lombok `@RequiredArgsConstructor` is ok). No `@Autowired` on fields.
- `@Transactional` in the service layer, not in the controller or the repository.
- Errors: domain exceptions + a central `@RestControllerAdvice`. No `try/catch` that swallows the exception or only calls `printStackTrace`.
- `Optional` only as a return type; never `.get()` without a check (use `orElseThrow`).
- Config via `@ConfigurationProperties`/`application.yml`; no magic values.
- Logging with SLF4J (`log.info("x={}", x)`), never `System.out`.

## Anti-patterns (blocking)
- JPA entity returned from the controller.
- N+1: a `LAZY` relation accessed in a loop without `fetch join`/`@EntityGraph`.
- `@Transactional` on a `private` method or on a method called from within the same class (does not work through the proxy).
- Native query built with string concatenation.
- Secrets in the versioned `application.yml`.
- Business logic in a controller, or an anemic entity + a giant service without justification.

## Tests
- Service: JUnit 5 + Mockito, without starting the Spring context.
- Controller: `@WebMvcTest` with the service mocked.
- Repository/custom queries: `@DataJpaTest` (Testcontainers if the project already uses it).
- Test names describe behavior (`shouldReturn404WhenOrderNotFound`).

## PR
- One topic per PR; migration (Flyway/Liquibase) together with the entity change.
- Description: context, affected endpoints/contracts, how to test.
