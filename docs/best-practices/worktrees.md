# Boas práticas — Git worktrees com agentes

Worktree = outro diretório de trabalho do mesmo repo, em outra branch. Permite
N agentes trabalhando em paralelo sem conflito de arquivos.

```bash
git worktree add ../app-wt/feat-badge -b feat/badge main
git worktree list
git worktree remove ../app-wt/feat-badge
```

No Claude Code: `isolation: "worktree"` no Agent tool, ou `claude --worktree`.

## Regras
1. **Uma tarefa = uma worktree = uma branch = um PR.**
2. Divida por **fronteira de arquivos**: se duas tarefas tocam o mesmo arquivo,
   não são paralelas — serialize.
3. Instale dependências em cada worktree (`node_modules` não é compartilhado),
   ou use pnpm/yarn com cache.
4. Portas: dev servers em paralelo precisam de portas diferentes (`PORT=...`).
5. Integração: faça merge dos PRs em ordem de dependência; rebase o resto.
6. Limpe: `git worktree prune` depois do merge.
