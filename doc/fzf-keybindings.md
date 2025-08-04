# fzf Key Bindings (command line fuzzy finder)

## Core Key Bindings

✅
❌

| Category | Key Binding | Description | Test |
|-----------|-------------|-------------|------|
| **File Search** | `CTRL-T` | Look for files and directories with preview | ✅ |
| **Directory Navigation** | `ALT-C` | Navigate to directories with tree preview | ✅ |
| **History Search** | `CTRL-R` | Look through command history | ✅ |
| **Selection** | `Enter` | Select the item | ✅ |
| **Navigation** | `Ctrl-j` or `Ctrl-n` or `Down arrow` | Go down one result | ✅ |
|  | `Ctrl-k` or `Ctrl-p` or `Up arrow` | Go up one result | ✅ |
| **Marking** | `Tab` | Mark a result | ✅ |
|  | `Shift-Tab` | Unmark a result | ✅ |

## Tab Completion with Preview

| Command | Description | Preview Content | Test |
|---------|-------------|-----------------|------|
| `cd **Tab` | Find directory to navigate to | Directory tree structure using `eza` | ✅ |
| `export **Tab` | Find environment variable to export | Current variable values | ✅ |
| `unset **Tab` | Find environment variable to unset | Current variable values | ✅ |
| `unalias **Tab` | Find alias to remove | Alias definitions | ✅ |
| `ssh **Tab` | Find host to SSH into | DNS information using `dig` | ✅ |
| `kill -9 **Tab` | Find process to terminate | Process details (PID, command, user) | ✅ |
| `vim **Tab` / `cat **Tab` | Find file for any command | Smart preview based on file type using `bat` | ✅ |

### Preview Controls

| Key Binding | Description | Test |
|-------------|-------------|------|
| `?` | Toggle preview window on/off - useful when you need more space for results | ✅ |
| `Ctrl-/` | Alternative key to toggle preview window | ✅ |
| `Shift-Up` or `Shift-Down` | Scroll through long files or command outputs vertically | ✅ |
| `Shift-Left` or `Shift-Right` | Scroll horizontally for wide content (long lines, tables) | ✅ |
| `Ctrl-B` or `Ctrl-F` | Jump through preview content in larger chunks (backward/forward) | ✅ |
| `Ctrl-A` or `Ctrl-E` | Jump to beginning or end of current line in preview | ✅ |

**Tips:**
- Preview window automatically resizes based on your terminal size
- Preview is context-aware: shows file content for files, directory tree for folders, process info for PIDs
- Use `--preview-window` options in your fzf config to customize preview position and size
