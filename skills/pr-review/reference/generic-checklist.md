# Checklist genérico de review

Use quando não houver `.claude/review-rules.md`; cobre as seções `Architecture`, `Required patterns`, `Anti-patterns (blocking)`, `Tests` e `PR` (legado: Arquitetura, Patterns obrigatórios, Anti-patterns (bloqueantes), Testes).

- [ ] O PR faz uma coisa só e o título descreve isso
- [ ] Nomes revelam intenção; sem abreviações obscuras
- [ ] Funções pequenas, sem efeitos colaterais escondidos
- [ ] Erros tratados ou propagados de forma explícita
- [ ] Sem código morto, console.log, TODO sem issue
- [ ] Testes para o caminho feliz e para pelo menos um caso de erro
- [ ] Sem segredos, tokens ou dados pessoais
- [ ] Dependências novas justificadas
- [ ] Mudanças de API/contrato documentadas
- [ ] Front: acessível por teclado, labels, contraste, estados de loading/erro/vazio
