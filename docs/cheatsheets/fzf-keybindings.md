# fzf Key Bindings (command line fuzzy finder)

## Core Key Bindings

| Category | Key Binding | Description |
|-----------|-------------|-------------|
| **File Search** | `CTRL-T` | Look for files and directories with preview |
| **Directory Navigation** | `ALT-C` | Navigate to directories with tree preview |
| **History Search** | `CTRL-R` | Look through command history |
| **Selection** | `Enter` | Select the item |
| **Navigation** | `Ctrl-j` or `Ctrl-n` or `Down arrow` | Go down one result |
|  | `Ctrl-k` or `Ctrl-p` or `Up arrow` | Go up one result |
| **Marking** | `Tab` | Mark or unmark the result, then move down |
|  | `Shift-Tab` | Mark or unmark the result, then move up |
| **Cancel** | `Esc` | Close fzf without choosing |

Marking works where several results can be picked: `CTRL-T`, `CTRL-R`, and `**` completion of files, variables and processes.

## Tab Completion with Preview

Type the command, then `**`, then `Tab`.

| Command | Description | Preview Content |
|---------|-------------|-----------------|
| `cd **Tab` | Find directory to navigate to | Directory tree structure using `eza` |
| `z **Tab` | Find directory to jump to with zoxide | Directory tree structure using `eza` |
| `export **Tab` | Find environment variable to export | Meant to show the value; empty today because of a bug in `.zshrc` |
| `unset **Tab` | Find environment variable to unset | Meant to show the value; empty today because of a bug in `.zshrc` |
| `unalias **Tab` | Find alias to remove | None useful: a "No such file" error |
| `ssh **Tab` | Find host to SSH into | DNS information using `dig` |
| `kill -9 **Tab` | Find process to terminate | No preview; each row shows user, PID, parent PID, start time, CPU time and command |
| `vim **Tab` / `cat **Tab` | Find file for any command | File content with line numbers using `bat`, or a folder tree using `eza` |

## Where previews appear

- `CTRL-T`: the file's content with line numbers (first 500 lines), or the folder's tree (first 200 lines).
- `ALT-C`: the folder's tree, two levels deep.
- Plain `Tab` after `cd` or `z`: when several folders match, fzf-tab opens a picker previewing each folder's contents.
- The fzf-git keys: each has its own preview; see [fzf-git-keybindings.md](fzf-git-keybindings.md).
- `CTRL-R`: no preview.

Long lines wrap in the `CTRL-T`, `ALT-C` and fzf-tab previews; in the `**` previews they are cut at the edge.

### Preview Controls

| Key Binding | Description |
|-------------|-------------|
| `Ctrl-/` | Toggle preview window on/off - useful when you need more space for results (added by the config) |
| `Shift-Up` or `Shift-Down` | Scroll the preview a line up or down (fzf's default) |
| `Shift-Left` or `Shift-Right` | Scroll the preview a page up or down. Changed: fzf's default moves one word in the search |

To move within the preview: `Shift-Up`/`Shift-Down` one line, `Shift-Left`/`Shift-Right` one page, or the mouse wheel over the preview. `Ctrl-/` hides it to give the list more room.

While you type the search, `Ctrl-A`, `Ctrl-E`, `Ctrl-B`, `Ctrl-F`, `Alt-B`, `Alt-F`, `Ctrl-U` and `Ctrl-W` edit it as in the shell, and `?` is typed as text (`man fzf`).

**Tips:**
- The preview takes the right half of the fzf window, so it grows and shrinks with your terminal
- Use `--preview-window` options in your fzf config to customize preview position and size
