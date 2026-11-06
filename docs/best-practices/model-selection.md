# Seleção de modelo por tarefa

Regra geral: **o modelo mais barato que acerta de primeira**. Errar e refazer custa mais
que subir um nível.

| Nível | Modelo | Use para | Sinais |
|---|---|---|---|
| 1 | **Haiku** | renomear, mover arquivos, CRUD óbvio, boilerplate, i18n, ajustar config, escrever teste para função pura já especificada, buscas/leitura ampla | 1–2 arquivos, padrão já existe no repo, critério de pronto objetivo |
| 2 | **Sonnet** | feature padrão, componente com estado, endpoint + teste, refactor local, integração com lib conhecida, PR review | 3–10 arquivos, segue arquitetura existente, poucas decisões |
| 3 | **Opus** | modelagem de dados, contexto/estado global, arquitetura nova, concorrência/tempo real, segurança, bug sem causa clara, planejar fases | decisões irreversíveis, muitos trade-offs, cruza camadas, ambíguo |

## Pontuação rápida (some os pontos)

- Arquivos tocados: 1–2 (0) · 3–10 (1) · >10 (2)
- Existe padrão igual no repo? sim (0) · parcial (1) · não (2)
- Decisão de design / dados / API pública? não (0) · sim (2)
- Ambiguidade no requisito? baixa (0) · média (1) · alta (2)
- Risco (segurança, migração, dados de usuário)? baixo (0) · alto (2)

**0–2 → Haiku · 3–5 → Sonnet · 6+ → Opus**

## Exemplos (front-end)

| Tarefa | Modelo |
|---|---|
| Criar `<Badge>` igual ao `<Tag>` existente | Haiku |
| Componente `<RentalForm>` com validação e teste | Sonnet |
| Criar `RentalContext` + reducer + persistência + sync com backend | Opus (planejar) → Sonnet (implementar) |
| Trocar polling por WebSocket no dashboard | Opus |
| Ajustar textos / cores / tokens | Haiku |

## Padrão "Opus planeja, Sonnet/Haiku executa"

Para tarefas nível 3, use Opus só para gerar o **spec** (interfaces, tipos, arquivos,
critérios de aceite) e delegue a implementação ao nível abaixo. É o melhor custo-benefício.
