# Zsh startup files

Which files each kind of zsh reads, in order.

| Order | File | Interactive login | Interactive non-login | Non-interactive login | Non-interactive non-login |
|-------|------|:-:|:-:|:-:|:-:|
| 1 | `/etc/zshenv` | ✓ | ✓ | ✓ | ✓ |
| 2 | `~/.zshenv` | ✓ | ✓ | ✓ | ✓ |
| 3 | `/etc/zprofile` | ✓ | | ✓ | |
| 4 | `~/.zprofile` | ✓ | | ✓ | |
| 5 | `/etc/zshrc` | ✓ | ✓ | | |
| 6 | `~/.zshrc` | ✓ | ✓ | | |
| 7 | `/etc/zlogin` | ✓ | | ✓ | |
| 8 | `~/.zlogin` | ✓ | | ✓ | |
| On exit | `~/.zlogout`, then `/etc/zlogout` | ✓ | | ✓ | |

Examples: a new macOS terminal tab or `ssh host` is interactive login; `zsh` typed at a prompt is interactive non-login; `ssh host command` is non-interactive login; a script, `zsh -c` or a tool such as Tilt starting a shell is non-interactive non-login.

On macOS, `~/.zshenv` turns off the automatic `/etc` files, and the repo sources `/etc/zshenv`, `/etc/zprofile` and `/etc/zshrc` by hand at the same points, so that macOS `path_helper` cannot reorder `PATH`. macOS ships no `/etc/zlogin` or `/etc/zlogout`. Why: [ADR 0004](../../.agents/adr/0004-path-order-over-path-helper.md).
