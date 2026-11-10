# Model selection by task

General rule: **the cheapest model that gets it right the first time**. Getting it wrong
and redoing the work costs more than moving up a level.

| Level | Model | Use for | Signals |
|---|---|---|---|
| 1 | **Haiku** | renaming, moving files, obvious CRUD, boilerplate, i18n, adjusting config, writing tests for an already specified pure function, broad searches/reading | 1–2 files, pattern already exists in the repo, objective done criteria |
| 2 | **Sonnet** | standard feature, stateful component, endpoint + test, local refactor, integration with a known lib, PR review | 3–10 files, follows existing architecture, few decisions |
| 3 | **Opus** | data modeling, global context/state, new architecture, concurrency/real time, security, bug without a clear cause, planning phases | irreversible decisions, many trade-offs, crosses layers, ambiguous |

## Two axes: model and effort

They are different things and are chosen separately:

- **Volume** (how much work) → chooses the **model**.
- **Reasoning** (how much doubt) → chooses the **effort**.

A small but ambiguous task yields more in `sonnet` with high effort than in
`opus` at the default effort — and costs less.

### Volume (V)

- Files touched: 1–2 (0) · 3–10 (1) · >10 (2)
- Is there an identical pattern in the repo? yes (0) · partial (1) · no (2)

### Reasoning (R)

- Design / data / public API decision? no (0) · yes (2)
- Ambiguity in the requirement? low (0) · medium (1) · high (2)
- Risk (security, migration, user data)? low (0) · high (2)

### Table

| | Sum | Choice |
|---|---|---|
| Model | V + R = 0–2 | Haiku |
| Model | V + R = 3–5 | Sonnet |
| Model | V + R = 6+ | Opus |
| Effort | R = 0–1 | default (do not pass `effort`) |
| Effort | R = 2–3 | `medium` |
| Effort | R = 4 | `high` |
| Effort | R = 5–6 | `xhigh` |

Two rules on top of this:

- **Low V and high R** (V ≤ 1 and R ≥ 4): prefer **Sonnet + `high`** over Opus. This is the
  case of "little code, hard decision".
- **`max` is never automatic.** It is only used if the user asks for it: it is the most
  expensive level.
- **No opus on the account:** replace it with `sonnet` + `xhigh` and **say that it was
  replaced**. Planning is little output and a lot of reasoning, so it is where the swap
  hurts least — but for high-risk tasks (R ≥ 5), it is worth waiting for opus instead of
  downgrading.

## Examples (front-end)

| Task | V | R | Model + effort |
|---|---|---|---|
| Create `<Badge>` like the existing `<Tag>` | 0 | 0 | Haiku, default |
| `<RentalForm>` component with validation and test | 1 | 1 | Sonnet, default |
| Choose the error format of the public API (1 file) | 0 | 4 | Sonnet + `high` |
| Create `RentalContext` + reducer + persistence + sync | 2 | 4 | Opus + `high` (plan) → Sonnet (implement) |
| Replace polling with WebSocket in the dashboard | 2 | 5 | Opus + `xhigh` |
| Adjust texts / colors / tokens | 0 | 0 | Haiku, default |

## "Opus plans, Sonnet/Haiku executes" pattern

For level 3 tasks, use Opus only to produce the **spec** (interfaces, types, files,
acceptance criteria) and delegate the implementation to the level below. It is the best
cost-benefit.
