# Scope

## In scope

- macOS with Homebrew and zsh: the only tested platform.
- Configuration for the shell, terminal tools and Neovim, in `home/`.
- Agent skills for personal use, in `skills/`.
- Bootstrap scripts: package install, Stow, theme setup.

## Untested

- Debian/Ubuntu: `scripts/install-packages.sh` and `.zsh/env.zsh` have Linux paths, but nothing verifies them. Fix them when found broken; do not claim support.

## Out of scope

- App state, including tool-generated defaults.
- Secrets and credentials.
- Work content and work-only tools or skills.
- Shells other than zsh. Bash is used only for scripts.
- Linux distributions other than Debian/Ubuntu.
