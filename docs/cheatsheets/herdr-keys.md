# herdr Keys

Press the prefix, release it, then the key. `?` after the prefix lists every binding.

| Key | Description |
|-----|-------------|
| `Ctrl-B` | Prefix |
| `Ctrl-B` | Pressed again after the prefix: send `Ctrl-B` to the program |
| `?` | Help: every key binding |
| `c` | New: opens the new menu; `Enter` makes a tab |
| `n` / `p` | Next / previous tab |
| `1`..`9` | Switch to tab 1 to 9 |
| `v` | Split side by side |
| `-` | Split stacked |
| `h` `j` `k` `l` | Focus the pane left, below, above, right |
| `Tab` | Next pane |
| `z` | Zoom the focused pane |
| `x` | Close the focused pane |
| `r` | Resize mode |
| `[` | Copy mode for the focused pane |
| `e` | Open the pane's scrollback in `$EDITOR` |
| `w` | Workspace picker |
| `Shift-N` | New workspace |
| `Shift-G` | New git worktree workspace |
| `g` | Session navigator |
| `o` | Focus the pane behind the visible notification |
| `b` | Toggle the sidebar |
| `s` | Settings |
| `q` | Detach (the session keeps running) |

The prefix hides `Ctrl-B` from everything running inside herdr: backward-char in zsh (use the left arrow), page up in fzf previews, yazi, nvim and less (use `PageUp`).
