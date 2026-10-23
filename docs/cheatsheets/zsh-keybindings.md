# Zsh Key Bindings (Emacs-style)

zsh's emacs keymap, as `man zshzle` documents it, except where marked as changed. See [fzf-keybindings.md](fzf-keybindings.md) for fzf's own keys.

| Category | Key Binding | Description |
|-----------|-------------|-------------|
| **Navigation** | `CTRL-A` | Move cursor to beginning of line |
|  | `CTRL-E` | Move cursor to end of line |
|  | `CTRL-B` | Move cursor backward one character (inside herdr, `CTRL-B` is the herdr prefix: use the left arrow) |
|  | `CTRL-F` | Move cursor forward one character |
|  | `ALT-B` | Move cursor to the beginning of the previous word |
|  | `ALT-F` | Move cursor to the beginning of the next word |
| **Deletion** | `CTRL-D` | Delete character under cursor (on an empty line: end of input) |
|  | `CTRL-H` | Delete character before cursor (backspace) |
|  | `ALT-D` | Delete word forward |
|  | `ALT-Backspace` | Delete word backward |
| **Kill & Yank** | `CTRL-K` | Kill (cut) from cursor to end of line |
|  | `CTRL-U` | Kill (cut) the whole line |
|  | `CTRL-Y` | Yank (paste) most recently killed text |
|  | `ALT-Y` | Cycle through kill ring (after CTRL-Y) |
|  | `ALT-W` | Changed: kill (cut) from the mark to the cursor; zsh's default copies instead. Set the mark with Ctrl-Space |
| **Text Manipulation** | `CTRL-T` | Changed: fzf file search; zsh's transpose-characters has no key now |
|  | `ALT-T` | Transpose words |
| **Search & Control** | `CTRL-R` | Changed: fzf history search; zsh's own incremental search stays on Ctrl-X r |
|  | `CTRL-S` | Forward incremental search (works because flow control is off) |
|  | `CTRL-P` | Changed: previous history line starting with the same first word; zsh's default (previous line) stays on the Up arrow |
|  | `CTRL-N` | Changed: next history line starting with the same first word; zsh's default stays on the Down arrow |
|  | `CTRL-G` | Cancel the line. Waits half a second first, because fzf-git uses `CTRL-G` to start its keys |
|  | `CTRL-L` | Clear screen |

`ALT-` keys need the terminal to send Option as Meta. WezTerm does this for the left Option key by default. WezTerm keeps `ALT-Enter` (full screen) and `CTRL-Minus` (smaller font), so zsh's newline-in-line and undo on those keys never arrive; undo stays on Ctrl-X u.
