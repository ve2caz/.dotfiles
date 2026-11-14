---
name: git-branch
description: "Create a ticket branch from the head of main and push it empty to the remote as a baseline."
disable-model-invocation: true
metadata:
  source: dotfiles
---

# git-branch

Creates a fresh branch from `main` and pushes it empty to the remote before any work begins.

## Steps

1. **Always ask the user which repository to use.** List the repos available in the current workspace and wait for an explicit answer. Do not infer from open files or recently viewed files.

2. Prompt the user for two pieces of information:
   - **Ticket ID** (e.g. `ABC-123`)
   - **Short descriptor** (e.g. `fix`, `add-ingress`, `refactor-sts`)

3. Construct the branch name: `<ID>-<descriptor>` (e.g. `ABC-123-fix`). Use only lowercase letters, digits, and hyphens in the descriptor.

4. Show the user the three commands below with the actual branch name substituted, then run them in order:

   ```bash
   git fetch origin
   ```
   ```bash
   git checkout -b <branch-name> origin/main
   ```
   ```bash
   git push -u origin <branch-name>
   ```

5. Confirm success: tell the user the branch `<branch-name>` is live on the remote and their working tree is on it, ready for work.

## Notes

- Always branch from `origin/main` (fetched fresh) so the baseline is the true head of main, regardless of which branch the user is currently on.
- The empty push establishes the remote branch before any commits, which is the required baseline.
- If the repo's default branch is not `main` (e.g. it is `master`), ask the user to confirm before running.
- Do not make any code changes, commits, or file edits as part of this skill.
