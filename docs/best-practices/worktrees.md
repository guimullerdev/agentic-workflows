# Best practices — Git worktrees with agents

A worktree is another working directory of the same repo, on another branch. It lets
N agents work in parallel without file conflicts.

```bash
git worktree add ../app-wt/feat-badge -b feat/badge main
git worktree list
git worktree remove ../app-wt/feat-badge
```

In Claude Code: `isolation: "worktree"` in the Agent tool, or `claude --worktree`.

## Rules
1. **One task = one worktree = one branch = one PR.**
2. Split by **file boundary**: if two tasks touch the same file, they are not parallel — serialize them.
3. Integration: merge the PRs in dependency order; rebase the rest.
4. Clean up: `git worktree prune` after the merge.
