# Zsh Key Bindings (Emacs-style)

zsh's emacs keymap, as `man zshzle` documents it, except where marked as changed. See [fzf-keybindings.md](fzf-keybindings.md) for fzf's own keys.

| Category | Key Binding | Description |
|-----------|-------------|-------------|
| **Navigation** | `CTRL-A` | Move cursor to beginning of line (inside herdr, `CTRL-A` is the herdr prefix: use `Home`, or press it twice) |
|  | `CTRL-E` | Move cursor to end of line |
|  | `CTRL-B` | Move cursor backward one character |
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
|  | `ALT-W` | Copy from the mark to the cursor. Set the mark with Ctrl-Space |
| **Text Manipulation** | `CTRL-T` | Changed: fzf file search; zsh's transpose-characters has no key now |
|  | `ALT-T` | Transpose words |
| **Search & Control** | `CTRL-R` | Changed: fzf history search; zsh's own incremental search stays on Ctrl-X r |
|  | `CTRL-S` | Forward incremental search (works because flow control is off) |
|  | `CTRL-P` | Previous history line. ALT-P finds the previous line starting with the same first word |
|  | `CTRL-N` | Next history line. ALT-N finds the next line starting with the same first word |
|  | `CTRL-G` | Cancel the line. Waits a moment first, because fzf-git uses `CTRL-G` to start its keys |
|  | `CTRL-L` | Clear screen |
|  | `CTRL-X CTRL-E` | Edit the command line in your editor; save and quit to bring it back |

`ALT-` keys need the terminal to send Option as Meta. WezTerm does this for the left Option key by default. WezTerm keeps `ALT-Enter` (full screen) and `CTRL-Minus` (smaller font), so zsh's newline-in-line and undo on those keys never arrive; undo stays on Ctrl-X u.
