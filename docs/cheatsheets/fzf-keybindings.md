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
| **Marking** | `Tab` | Mark a result |
|  | `Shift-Tab` | Unmark a result |

## Tab Completion with Preview

| Command | Description | Preview Content |
|---------|-------------|-----------------|
| `cd **Tab` | Find directory to navigate to | Directory tree structure using `eza` |
| `export **Tab` | Find environment variable to export | Current variable values |
| `unset **Tab` | Find environment variable to unset | Current variable values |
| `unalias **Tab` | Find alias to remove | Alias definitions |
| `ssh **Tab` | Find host to SSH into | DNS information using `dig` |
| `kill -9 **Tab` | Find process to terminate | Process details (PID, command, user) |
| `vim **Tab` / `cat **Tab` | Find file for any command | Smart preview based on file type using `bat` |

### Preview Controls

| Key Binding | Description |
|-------------|-------------|
| `Ctrl-/` | Toggle preview window on/off - useful when you need more space for results |
| `Shift-Up` or `Shift-Down` | Scroll the preview a line up or down |
| `Shift-Left` or `Shift-Right` | Scroll the preview a page up or down |

`Ctrl-A`, `Ctrl-E`, `Ctrl-B`, `Ctrl-F` and `?` keep their usual meaning while you type the search.

**Tips:**
- Preview window automatically resizes based on your terminal size
- Preview is context-aware: shows file content for files, directory tree for folders, process info for PIDs
- Use `--preview-window` options in your fzf config to customize preview position and size
