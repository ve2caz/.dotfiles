# fzf-git Key Bindings (interactive Git operations with fzf)

Hold `CTRL`, press `G`, then the second key. Works inside a git repository; the pick is inserted into the command line. Move within the preview as in any fzf preview (see [fzf-keybindings.md](fzf-keybindings.md)).

| Category | Key Binding | Description | Preview |
|-----------|-------------|-------------|---------|
| **Git Files** | `CTRL-GF` | Look for git files with fzf | The file's uncommitted changes, then its content |
| **Git Branches** | `CTRL-GB` | Look for git branches with fzf | The branch's log as a graph |
| **Git Tags** | `CTRL-GT` | Look for git tags with fzf | The tag (`git show`) |
| **Git Remotes** | `CTRL-GR` | Look for git remotes with fzf | The log of the current branch on that remote |
| **Git History** | `CTRL-GH` | Look for git commit hashes with fzf | The commit (`git show`) |
| **Git Stash** | `CTRL-GS` | Look for git stashes with fzf | The stash (`git show`) |
| **Git Logs** | `CTRL-GL` | Look for git reflogs with fzf | The reflog entry (`git show`) |
| **Git Worktrees** | `CTRL-GW` | Look for git worktrees with fzf | The worktree's status and log |
| **Git References** | `CTRL-GE` | Look for git for-each-ref with fzf | The reference's log as a graph |
