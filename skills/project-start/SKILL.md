---
name: project-start
description: >-
  Começa um projeto do zero já com o fluxo agentic-workflows (ideia → stack →
  esqueleto → plano → ciclo de fases) e, quando chamada sem argumento num projeto
  existente, lê docs/WORKFLOW.md e diz em que etapa o projeto está e qual o
  próximo comando. Use quando o usuário disser "vou criar um app novo", "começa
  um projeto do zero", "não sei por onde começar", "onde eu parei?", "qual o
  próximo passo?" ou digitar /project-start.
argument-hint: "[\"<ideia do app em uma frase>\"] [--stack <stack>] [--no-scaffold]"
---

# project-start

Duas formas:
- **Com ideia** (repo vazio ou quase): faz o Setup (etapas 0–1 do `WORKFLOW.md`) e para.
- **Sem argumento** e `docs/WORKFLOW.md` existe: modo "onde estou" (passo 6).

Modelos ficam neste repo em `templates/project/` (`CLAUDE.md`, `.claude/review-rules.md`,
`docs/WORKFLOW.md`) e `templates/review-rules/<stack>.md`. Ache o caminho seguindo o
symlink desta skill (`readlink -f ~/.claude/skills/project-start`).

## Regras inegociáveis
- Não cria o plano: isso é do `/plan-create`, em outra sessão. Não implementa feature.
- Uma decisão de cada vez, com recomendação. Não grava nada antes do usuário aprovar
  a ficha do passo 2.
- Nunca sobrescreve arquivo existente sem mostrar o diff.

## Passos

### 1. Entrevista curta (no máximo 5 perguntas, use AskUserQuestion)
- O que o app faz e para quem (resultado observável, não "um app legal").
- Plataforma: web, mobile, API, CLI, desktop.
- Stack: se o usuário não tem preferência, recomende **uma** com motivo de uma linha
  (padrão do usuário: React/Next no front, NestJS ou Spring no back).
- Restrições: prazo, hospedagem, banco, auth, orçamento.
- O que fica **fora** da v1.

### 2. Ficha do projeto
Mostre em até 15 linhas: nome, objetivo, stack, comandos esperados (dev/test/lint),
estrutura de pastas inicial, fora de escopo e perguntas em aberto. Espere aprovação.

### 3. Esqueleto (pule com `--no-scaffold`)
- `git init` se não for repo; branch `main`.
- Gere o esqueleto pelo gerador oficial da stack (`create-next-app`, `nest new`,
  `spring init`, `npm create vite`…), não à mão. Peça confirmação antes de rodar.
- Garanta um teste trivial verde e o comando de teste funcionando.
- `.gitignore` da stack.

### 4. Configuração do fluxo
- `CLAUDE.md` a partir do template, preenchido com a ficha (≤ 60 linhas).
- `.claude/review-rules.md` a partir de `templates/review-rules/<stack>.md`; sem
  modelo da stack, parta de `templates/project/.claude/review-rules.md`. Marque o que é
  **inferido** — em projeto novo quase tudo é; vai ser refinado com
  `/project-skill-bootstrap` depois que houver código.
- `docs/WORKFLOW.md` a partir do template: marque `[x]` nas etapas 0 e 1 concluídas,
  State = "Etapa 2 — Plano", data de hoje, e uma linha no History.

### 5. Commit e entrega
- Um commit `chore: bootstrap project with agentic workflow` na `main` (repo novo
  não tem PR para revisar). Repo já existente → branch `chore/bootstrap` e PR.
- Termine com exatamente o próximo passo, para rodar **em sessão nova**:
  `/plan-create "<objetivo da ficha>"`.

### 6. Modo "onde estou" (sem argumento)
- Leia `docs/WORKFLOW.md`, `docs/PLAN.md` e `gh pr list --state open`.
  Os cabeçalhos do `WORKFLOW.md` podem estar em inglês ou nos legados em português.
  Trate como equivalentes: State = Estado; Cycle = Ciclo; Cycle rules = Regras do ciclo;
  History = Histórico; "If State says…" = "Se o Estado diz…" (Setup é igual).
- Confronte o State com a realidade (fase marcada sem PR mergeado, PR mergeado com
  fase aberta…) e corrija o State se estiver desatualizado, mostrando o diff.
- Responda em 3 linhas: etapa atual, o que falta para fechá-la, próximo comando
  (use a tabela "If State says…" do `WORKFLOW.md`).
- Sem `WORKFLOW.md` mas com código: ofereça criá-lo a partir do template e rodar
  `/project-skill-bootstrap`.
