---
name: git-clean-local-branches
description: "Propose which local git branches are safe to delete, then delete only the ones you approve."
disable-model-invocation: true
metadata:
  source: dotfiles
---

# Clean local git branches

Inventory local branches, propose a safe delete list, then adjust that list in conversation.

ALWAYS REQUIRE APPROVAL prior to deleting branches!

The inventory script is read-only. It does not fetch, prune, checkout, or delete.

## Steps

1. If the workspace has more than one git repo, ask which repo to clean. Do not infer from open files.

2. From that repo's working tree, run the bundled script from this skill's `scripts/` folder and show the user the full output:

   ```bash
   bash "<this skill's folder>/scripts/inventory-local-branches.sh"
   ```

3. Present the `WORKTREES` list first: path, branch, role (`primary` or `linked`), and locked. Then present one table with every local branch. Include: name, current branch, worktree path, has upstream, upstream name, upstream track (`ahead` / `behind` / `gone`), ever pushed, evidence, commits not on any remote, commits not in the default branch, and the proposal (`remove` or `keep`) with its reason.

4. Propose only the rows marked `remove`. State why each is safe:
   - `commits-on-a-remote`: every commit is already on a remote-tracking ref
   - `merged-into-<default>`: every commit is already in the local default branch

   Do not propose the current branch, the default branch, a branch checked out in a worktree, or a branch with commits that are neither on a remote nor in the default branch.

5. Stop and talk. Ask the user what to preserve or also clean. Apply their changes to the list and show the revised list. Repeat until they approve one exact list.

   A branch whose `worktree_path` is not `-` is locked. Do not add it because the user said "delete them", "clean everything", or "also clean that one". Tell them the path that has it checked out. This skill does not remove, prune, unlock, or move worktrees, and it does not delete worktree directories. That branch stays until the user has dealt with the worktree and a new inventory shows `worktree_path` as `-`.

6. Delete only the approved names, one command at a time, with `git branch -d`. Do not chain deletes. Do not use `git branch -D`, `git push`, or `git fetch` unless the user explicitly approves that command for those branches.

   Immediately before each delete, run `git worktree list --porcelain` again. If that branch is checked out at any path, skip it, report the path, and leave the branch in place.

   If `git branch -d` refuses a branch, stop on that branch, show the error, and leave it in place. Force-delete only after the user explicitly approves `git branch -D` for that branch, after you have said which commits exist only on it.

## How to read the inventory

- **Has upstream**: `branch.<name>.remote` and `branch.<name>.merge` are set. `upstream_track` of `[gone]` means the tracking ref is missing locally.
- **Ever pushed**: `yes` when an upstream is configured (including `[gone]`), a matching `refs/remotes/<remote>/<branch>` exists, or that remote-tracking reflog file still exists. Otherwise `no`. This is local evidence. It does not contact the server.
- A branch can have been pushed without an upstream (`ever_pushed=yes`, `has_upstream=no`) when a remote-tracking ref or reflog exists but tracking was never set.
- A branch can have an upstream and still be unsafe to delete when `unique_vs_remotes` is greater than 0 (local commits are not on any remote-tracking ref).

Evidence is local and can be stale. Offer `git fetch --prune` only if the user wants a fresher upstream picture, and wait for approval before running it. Re-run the inventory after a prune. Do not delete from a stale proposal.

## Notes

- Do not delete branches as part of presenting the proposal.
- Do not make code changes, commits, or other git writes in this workflow.
- Do not run `git worktree remove`, `git worktree prune`, `git worktree unlock`, or delete a worktree directory. A linked worktree is a separate checkout; deleting its branch breaks that checkout.
- An explicit "delete them" applies only to the list last shown. If the list changed, show it again and wait.
