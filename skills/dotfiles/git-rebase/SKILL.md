---
name: git-rebase
description: "Rebase the current branch onto the remote trunk, keeping staged, unstaged and untracked work."
disable-model-invocation: true
metadata:
  source: dotfiles
---

# git-rebase

Rebase the current branch onto the latest remote trunk. Preserve all in-progress work: staged, unstaged, and untracked.

Do not use `git rebase --autostash`. It does not include untracked files.

## Steps

1. Confirm the git repository. If the workspace has more than one repo, ask which to use. Do not infer from open files.

2. From that repo's working tree, run the bundled script from this skill's `scripts/` folder (request network/SSH permissions if fetch is sandboxed):

   ```bash
   bash "<this skill's folder>/scripts/rebase-onto-trunk.sh"
   ```

   The script fetches `origin`, rebases onto trunk (`origin/HEAD`, else `origin/main`, else `origin/master`), and round-trips work with `git stash push --include-untracked`.

3. Report the script summary: branch, trunk, behind/ahead counts, rebase result, stash restored or kept, and whether the remote has diverged.

4. Do not push. If `FORCE_WITH_LEASE_NEEDED=yes`, tell the user that updating the remote requires `git push --force-with-lease` and wait for an explicit ask. Never force-push `main` or `master`.

## Failures

- **Rebase conflicts:** the script leaves the rebase in progress and keeps the stash. After the user resolves conflicts:

  ```bash
  git rebase --continue
  ```

  ```bash
  git stash pop --index
  ```

  To abandon:

  ```bash
  git rebase --abort
  ```

  ```bash
  git stash pop --index
  ```

- **Stash pop failed:** do not drop the stash. Show `git stash list` and the `STASH_TOKEN` from the script.

- **Already in a rebase, merge, cherry-pick, revert, or detached HEAD:** stop. Do not stash or rebase.

## Notes

- This stash is a round-trip to preserve work, not a discard. Do not skip it even if project rules discourage `git stash`.
- Ignored files are not stashed (`--include-untracked`, not `--all`).
- Do not make code changes, commits, or extra git writes beyond what the script and conflict recovery require.
