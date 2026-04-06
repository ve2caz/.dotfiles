# Overview

## What this repository is

A personal **dotfiles** tree: shell configuration, terminal tooling, editor config, and helper scripts. It is meant to be cloned to `~/.dotfiles` and activated with **GNU Stow** so configuration files are symlinked into `$HOME` and `$XDG_CONFIG_HOME`.

## Platforms

- **macOS** — primary path uses Homebrew (`Brewfile`, `brew bundle`).
- **Linux** — **Debian/Ubuntu** only for automated installs (`scripts/install-packages.sh`). Other distros are not supported by the installer; manual package installation would be required.

Setup and maintenance details: [`doc/setup.md`](../doc/setup.md), [`doc/requirements.md`](../doc/requirements.md).

## What is out of scope

- **Secrets and machine-local state** — not committed. Examples: SSH keys, API tokens, private app configs. Several paths are listed in [`.gitignore`](../.gitignore).
- **One-off editor caches** — e.g. under `.config/cursor/`, `.config/lnav/` view JSON; ignore patterns exist so they do not pollute the repo.

## Human-facing docs

The [`README.md`](../README.md) is the quick start for people. [`doc/tools.md`](../doc/tools.md) lists included CLI tools. Use those for long-form explanations; agent briefs in `.agents/` focus on **what to run** and **what not to break**.
