# Zsh Key Bindings (Emacs-style)

> **Note**: Some key bindings are overridden by fzf when enabled. See `fzf-keybindings.md` for fzf-specific bindings.

| Category | Key Binding | Description | Test |
|-----------|-------------|-------------|------|
| **Navigation** | `CTRL-A` | Move cursor to beginning of line | ✅ |
|  | `CTRL-E` | Move cursor to end of line | ✅ |
|  | `CTRL-B` | Move cursor backward one character | ✅ |
|  | `CTRL-F` | Move cursor forward one character | ✅ |
|  | `ALT-B` | Move cursor backward one word | ❌ |
|  | `ALT-F` | Move cursor forward one word | ❌ |
| **Deletion** | `CTRL-D` | Delete character under cursor | ✅ |
|  | `CTRL-H` | Delete character before cursor (backspace) | ✅ |
|  | `ALT-D` | Delete word forward | ❌ |
|  | `ALT-Backspace` | Delete word backward | ✅ |
| **Kill & Yank** | `CTRL-K` | Kill (cut) from cursor to end of line | ✅ |
|  | `CTRL-U` | Kill (cut) from cursor to beginning of line | ✅ |
|  | `CTRL-Y` | Yank (paste) most recently killed text | ✅ |
|  | `ALT-Y` | Cycle through kill ring (after CTRL-Y) | ❓ |
|  | `ALT-W` | Cut/kill selected region (custom) | ❓ |
| **Text Manipulation** | `CTRL-T` | Transpose characters (overridden by fzf file search) | ✅ |
|  | `ALT-T` | Transpose words | ❌ |
| **Search & Control** | `CTRL-R` | Reverse incremental search (overridden by fzf history search) | ✅ |
|  | `CTRL-S` | Forward incremental search | ❌ |
|  | `CTRL-P` | Search backward in command history (custom) | ✅ |
|  | `CTRL-N` | Search forward in command history (custom) | ✅ |
|  | `CTRL-G` | Cancel current operation | ❌ |
|  | `CTRL-L` | Clear screen | ✅ |
