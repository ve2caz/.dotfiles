# Setup and scripts

## Full bootstrap

From the repository root (typically `~/.dotfiles`):

```bash
./scripts/setup.sh
```

This orchestrates:

1. **`scripts/install-packages.sh`** — OS detection, package installs (brew on macOS, apt on Debian/Ubuntu), fonts, and related tool setup (e.g. Zinit, TPM, fzf-git) as implemented in the script.
2. **`stow . --target="$HOME"`** — symlinks dotfiles into the home tree (requires **GNU Stow**).
3. **`scripts/setup-tokyo-night-theme.sh`** — Tokyo Night theme alignment for bat, yazi, etc.

Shell note: setup scripts use **bash** (`set -e`) so they run on fresh systems before zsh config is fully in place.

## Partial workflows

| Goal | Command |
|------|---------|
| Packages only | `./scripts/install-packages.sh` |
| Stow only (packages already installed) | `stow . --target="$HOME"` from repo root |
| Tokyo Night only | `./scripts/setup-tokyo-night-theme.sh` |
| Verify installed CLIs | `./scripts/check-installation.sh` |
| macOS: Brewfile only | `brew bundle` (see [`doc/setup.md`](../doc/setup.md)) |

## Dependency graph (conceptual)

```
setup.sh
├── install-packages.sh
├── stow . --target=$HOME
└── setup-tokyo-night-theme.sh
```

## Mise (optional)

[Mise](https://mise.jdx.dev/) may be installed by the bootstrap. Per-project runtimes use `.mise.toml`; global behavior is covered in [`doc/setup.md`](../doc/setup.md). PATH and shim ordering matter for shell tests — see [`testing.md`](testing.md).

## Cross-platform package mapping

[`doc/cross-platform-tools.md`](../doc/cross-platform-tools.md) explains how Brewfile tools map on Linux.
