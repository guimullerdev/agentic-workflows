# Regras de review — <Projeto> (Java / Spring Boot)

> Copie para `<projeto>/.claude/review-rules.md` e ajuste. Apague o que não se aplica.

## Arquitetura
- Camadas: `controller` → `service` → `repository`. Nunca pular camada nem inverter.
  (Se o projeto usa hexagonal/clean: `adapter.in` → `application/usecase` → `domain` ← `adapter.out`;
  `domain` não importa Spring nem JPA.)
- Pacote por feature: `com.<empresa>.<app>.<feature>.{controller,service,repository,dto,domain}`.
- Exemplo de feature correta: `<caminho>`

## Patterns obrigatórios
- **Controller**: recebe/valida (`@Valid` + Bean Validation no DTO), chama service, devolve `ResponseEntity`/DTO. Sem regra de negócio.
- **DTO separado da entidade**: nunca expor `@Entity` na API. Mapear com MapStruct ou mapper explícito. Preferir `record` para DTOs.
- Injeção **por construtor** (campos `final`, Lombok `@RequiredArgsConstructor` ok). Nada de `@Autowired` em campo.
- `@Transactional` na camada de service, não no controller nem no repository.
- Erros: exceções de domínio + `@RestControllerAdvice` central. Sem `try/catch` que engole exceção ou só faz `printStackTrace`.
- `Optional` só como retorno; nunca `.get()` sem checagem (usar `orElseThrow`).
- Config via `@ConfigurationProperties`/`application.yml`; sem valores mágicos.
- Log com SLF4J (`log.info("x={}", x)`), nunca `System.out`.

## Anti-patterns (bloqueantes)
- Entidade JPA retornada no controller.
- N+1: relação `LAZY` acessada em loop sem `fetch join`/`@EntityGraph`.
- `@Transactional` em método `private` ou chamado de dentro da mesma classe (não funciona via proxy).
- Query nativa com concatenação de string.
- Segredos no `application.yml` versionado.
- Lógica de negócio em controller ou em entidade anêmica + service gigante sem justificativa.

## Testes
- Service: JUnit 5 + Mockito, sem subir contexto Spring.
- Controller: `@WebMvcTest` com service mockado.
- Repository/queries customizadas: `@DataJpaTest` (Testcontainers se o projeto já usa).
- Nome do teste descreve comportamento (`shouldReturn404WhenOrderNotFound`).

## PR
- Um assunto por PR; migration (Flyway/Liquibase) junto da mudança de entidade.
- Descrição: contexto, endpoints/contratos afetados, como testar.
