# tmux Key Bindings

> **Note**: These are the custom tmux key bindings based on the current .tmux.conf configuration. The prefix key has been changed from the default `CTRL-B` to `CTRL-A`.

## Quick Reference Commands (Terminal)

| Command | Description | Test |
|---------|-------------|------|
| `tmux` | Start new tmux session | ✅ |
| `tmux new -s <name>` | Start new session with name | ✅ |
| `tmux attach -t <name>` | Attach to existing session | ✅ |
| `tmux list-sessions` | List all sessions | ✅ |
| `tmux kill-session -t <name>` | Kill specific session | ✅ |


## Common Commands (via Command Mode)

| Command | Description | Test |
|---------|-------------|------|
| `:list-sessions` | List all sessions | ✅ |
| `:kill-session -t <name>` | Kill specific session | ✅ |
| `:kill-server` | Kill tmux server and all sessions | ✅ |
| `:source-file ${XDG_CONFIG_HOME}/tmux/tmux.conf` | Reload configuration file | ✅ |
| `:show-options -g` | Show global options | ✅ |
| `:list-keys` | List all key bindings | ✅ |

## Session Management

| Category | Key Binding | Description | Test |
|-----------|-------------|-------------|------|
| **Session Control** | `PREFIX :new-session` | Create new session | ✅ |
|  | `PREFIX s` | List and switch between sessions | ✅ |
|  | `PREFIX $` | Rename current session | ✅ |
|  | `PREFIX d` | Detach from current session | ✅ |
|  | `PREFIX :kill-session` | Kill current session | ✅ |

## Window Management

| Category | Key Binding | Description | Test |
|-----------|-------------|-------------|------|
| **Window Creation** | `PREFIX c` | Create new window | ✅ |
|  | `PREFIX ,` | Rename current window | ✅ |
| **Window Navigation** | `PREFIX n` | Next window | ✅ |
|  | `PREFIX p` | Previous window | ✅ |
|  | `PREFIX l` | Last window | ✅ |
|  | `PREFIX 0-9` | Switch to window by number | ✅ |
|  | `PREFIX w` | List and select windows | ✅ |
| **Window Control** | `PREFIX &` | Kill current window (with confirmation) | ✅ |

## Pane Management

| Category | Key Binding | Description | Test |
|-----------|-------------|-------------|------|
| **Pane Creation** | `PREFIX \|` | Split window vertically (left/right) | ✅ |
|  | `PREFIX -` | Split window horizontally (top/bottom) | ✅ |
| **Pane Navigation** | `PREFIX o` | Switch to next pane | ✅ |
|  | `PREFIX ;` | Switch to last active pane | ✅ |
|  | `PREFIX {` | Move current pane left | ✅ |
|  | `PREFIX }` | Move current pane right | ✅ |
|  | `PREFIX ↑↓←→` | Switch to pane in direction | ✅ |
| **Pane Resizing** | `PREFIX h` | Resize pane left (5 cells) | ✅ |
|  | `PREFIX j` | Resize pane down (5 cells) | ✅ |
|  | `PREFIX k` | Resize pane up (5 cells) | ✅ |
|  | `PREFIX l` | Resize pane right (5 cells) | ✅ |
| **Pane Layout** | `PREFIX SPACE` | Cycle through pane layouts | ✅ |
|  | `PREFIX !` | Break pane into new window | ✅ |
|  | `PREFIX x` | Kill current pane (with confirmation) | ✅ |
|  | `PREFIX m` | Toggle pane zoom (fullscreen) | ✅ |

## Copy Mode

| Category | Key Binding | Description | Test |
|-----------|-------------|-------------|------|
| **Enter Copy Mode** | `PREFIX [` | Enter copy mode | ❓ |
| **Navigation** | `h,j,k,l` | Move cursor (vi-style) | ❓ |
|  | `↑↓←→` | Move cursor (arrow keys) | ❓ |
|  | `w` | Move forward by word | ❓ |
|  | `b` | Move backward by word | ❓ |
|  | `0` | Move to beginning of line | ❓ |
|  | `$` | Move to end of line | ❓ |
|  | `g` | Go to top of buffer | ❓ |
|  | `G` | Go to bottom of buffer | ❓ |
| **Selection** | `v` | Start selection (vi mode) | ❓ |
|  | `y` | Copy selection (vi mode) | ❓ |
|  | `Escape` | Exit copy mode without copying | ❓ |
| **Search** | `/` | Search forward | ❓ |
|  | `?` | Search backward | ❓ |
|  | `n` | Next search result | ❓ |
|  | `N` | Previous search result | ❓ |

> **Note**: Copy mode is configured to use vi key bindings. Mouse drag selection is enabled and won't exit copy mode automatically.

## Miscellaneous

| Category | Key Binding | Description | Test |
|-----------|-------------|-------------|------|
| **Information** | `PREFIX ?` | List all key bindings | ✅ |
|  | `PREFIX i` | Display window information | ✅ |
|  | `PREFIX t` | Show time | ✅ |
| **Command Mode** | `PREFIX :` | Enter command mode | ✅ |
| **Reload** | `PREFIX r` | Reload tmux config | ✅ |
| **Paste** | `PREFIX ]` | Paste most recent buffer | ✅ |

## Additional Features

| Category | Feature | Description | Test |
|-----------|---------|-------------|------|
| **Mouse Support** | Mouse enabled | Mouse support is enabled for pane selection, resizing, and scrolling | ✅ |
| **Plugin Navigation** | `CTRL-h,j,k,l` | Navigate between tmux panes and vim/nvim (vim-tmux-navigator plugin) | ✅ |
| **Session Persistence** | Auto-save/restore | Sessions are automatically saved every 15 minutes and restored on restart | ✅ |

## Installed Plugins

| Plugin | Description | Test |
|---------|-------------|------|
| `tpm` | Tmux Plugin Manager | ✅ |
| `vim-tmux-navigator` | Seamless navigation between tmux panes and vim/nvim | ✅ |
| `tmux-themepack` | Theme pack (using powerline/default/cyan theme) | ✅ |
| `tmux-resurrect` | Save and restore tmux sessions | ✅ |
| `tmux-continuum` | Automatic session saving | ✅ |
