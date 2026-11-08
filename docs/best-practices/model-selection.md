# Seleção de modelo por tarefa

Regra geral: **o modelo mais barato que acerta de primeira**. Errar e refazer custa mais
que subir um nível.

| Nível | Modelo | Use para | Sinais |
|---|---|---|---|
| 1 | **Haiku** | renomear, mover arquivos, CRUD óbvio, boilerplate, i18n, ajustar config, escrever teste para função pura já especificada, buscas/leitura ampla | 1–2 arquivos, padrão já existe no repo, critério de pronto objetivo |
| 2 | **Sonnet** | feature padrão, componente com estado, endpoint + teste, refactor local, integração com lib conhecida, PR review | 3–10 arquivos, segue arquitetura existente, poucas decisões |
| 3 | **Opus** | modelagem de dados, contexto/estado global, arquitetura nova, concorrência/tempo real, segurança, bug sem causa clara, planejar fases | decisões irreversíveis, muitos trade-offs, cruza camadas, ambíguo |

## Dois eixos: modelo e effort

São coisas diferentes e se escolhem separado:

- **Volume** (quanto trabalho) → escolhe o **modelo**.
- **Raciocínio** (quanta dúvida) → escolhe o **effort**.

Uma tarefa pequena mas ambígua rende mais em `sonnet` com effort alto do que em
`opus` no effort padrão — e custa menos.

### Volume (V)

- Arquivos tocados: 1–2 (0) · 3–10 (1) · >10 (2)
- Existe padrão igual no repo? sim (0) · parcial (1) · não (2)

### Raciocínio (R)

- Decisão de design / dados / API pública? não (0) · sim (2)
- Ambiguidade no requisito? baixa (0) · média (1) · alta (2)
- Risco (segurança, migração, dados de usuário)? baixo (0) · alto (2)

### Tabela

| | Soma | Escolha |
|---|---|---|
| Modelo | V + R = 0–2 | Haiku |
| Modelo | V + R = 3–5 | Sonnet |
| Modelo | V + R = 6+ | Opus |
| Effort | R = 0–1 | padrão (não passe `effort`) |
| Effort | R = 2–3 | `medium` |
| Effort | R = 4 | `high` |
| Effort | R = 5–6 | `xhigh` |

Duas regras em cima disso:

- **V baixo e R alto** (V ≤ 1 e R ≥ 4): prefira **Sonnet + `high`** a Opus. É o caso de
  "pouco código, decisão difícil".
- **`max` nunca é automático.** Só se o usuário pedir: é o nível mais caro.

## Exemplos (front-end)

| Tarefa | V | R | Modelo + effort |
|---|---|---|---|
| Criar `<Badge>` igual ao `<Tag>` existente | 0 | 0 | Haiku, padrão |
| Componente `<RentalForm>` com validação e teste | 1 | 1 | Sonnet, padrão |
| Escolher o formato de erro da API pública (1 arquivo) | 0 | 4 | Sonnet + `high` |
| Criar `RentalContext` + reducer + persistência + sync | 2 | 4 | Opus + `high` (planejar) → Sonnet (implementar) |
| Trocar polling por WebSocket no dashboard | 2 | 5 | Opus + `xhigh` |
| Ajustar textos / cores / tokens | 0 | 0 | Haiku, padrão |

## Padrão "Opus planeja, Sonnet/Haiku executa"

Para tarefas nível 3, use Opus só para gerar o **spec** (interfaces, tipos, arquivos,
critérios de aceite) e delegue a implementação ao nível abaixo. É o melhor custo-benefício.
