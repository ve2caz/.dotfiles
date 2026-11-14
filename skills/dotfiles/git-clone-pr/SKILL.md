---
name: git-clone-pr
description: "Create a git worktree from a GitHub pull request for local code review."
disable-model-invocation: true
metadata:
  source: dotfiles
---

# git-clone-pr

Creates a git worktree from a GitHub PR branch for local code review.
Uses plain `git` only - no `gh` CLI required.

## Local disk layout

```
{root}/{org}/{repo}                        <- main clone
{root}/{org}/{repo}-worktree/{branch}      <- worktrees
```

Example: PR 42 on `my-org/my-repo` with branch `ABC-456-add-endpoint`:
```
{root}/my-org/my-repo-worktree/ABC-456-add-endpoint
```

## Workflow

1. **Find the repo root and derive paths:**
   ```
   git rev-parse --show-toplevel
   ```
   `{repo}` is that folder's name, `{org}` its parent folder's name, and `{root}` the folder above `{org}`.

2. **Extract the PR number** from whatever the user provided (bare number or GitHub URL).

3. **Resolve the branch name from the remote:**
   ```
   SHA=$(git ls-remote origin 'refs/pull/<N>/head' | awk '{print $1}')
   git ls-remote origin 'refs/heads/*' | grep "$SHA"
   ```
   Strip `refs/heads/` to get `{branch}`.

4. **Fetch the PR head directly into a local branch named after the real branch:**
   ```
   git fetch origin pull/<N>/head:{branch}
   ```

5. **Create the worktree:**
   ```
   mkdir -p {root}/{org}/{repo}-worktree
   git worktree add {root}/{org}/{repo}-worktree/{branch} {branch}
   ```

6. **Report** the full worktree path and cleanup commands:
   ```
   git worktree remove {root}/{org}/{repo}-worktree/{branch}
   git branch -d {branch}
   ```

## Assumptions

- Git 2.5+
- No forks - all PRs are same-repo branches targeting trunk
- Open PRs always have their branch live on `origin` (GitHub prevents deletion)
- Remote is named `origin`
