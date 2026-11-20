# 0009: Every change reaches main through a pull request

Status: accepted, 2026-11-20.

**Context.** Agents edited files on `main` in the main checkout and created a branch only when committing, more than once. `main` should only ever hold reviewed, merged work. The links Stow creates in `$HOME` point into `~/.dotfiles`, so whatever the main checkout has checked out, edits included, is live in every new shell and tool. The repo is public, so nothing goes to GitHub without the user's go-ahead.

**Decision.** No edit is ever made on `main`. The branch or worktree is created before the first edit, and every change reaches `main` through a pull request that the user reviews and merges.

- **Small change, branch and pull request:** a focused change done in one sitting, such as a config line, an alias, or a doc fix. Create a branch in the main checkout (`git switch -c <branch>`) before editing. The change is live while the branch is checked out, which is how it gets tested. After the pull request, switch the main checkout back to `main`.
- **Large change, worktree and pull request:** work spanning several commits or sessions, several unrelated files, or anything that could break shells or tools while half done, such as zsh startup or `PATH`. Create a worktree (`wt switch -c <branch>`, under `~/.dotfiles-worktree/<branch>`) and work there. The main checkout stays on `main`, so the live setup keeps working. Test the worktree's files from the worktree, for example with a temporary `HOME` as the tests do, before the pull request.
- One concern per branch. A second, unrelated change gets its own branch from `main`, even mid-task.
- Pushing and opening the pull request need the user's go-ahead, and only the user merges.

**Alternatives rejected.** Committing to `main` directly: no review, and a mistake is live and public at once. A worktree for every change: a small change could not be tried in the live setup without deploying the worktree, and each one costs a checkout. A branch for every change: a large, half-done change would be live in every new shell while it is broken.

**Consequences.** When in doubt between small and large, use a worktree. When the main checkout is found on a branch other than `main`, ask before switching it: its files are what `$HOME` runs. The doctor checks the main checkout's files, so after a pull request merges, run it again from `main`.
