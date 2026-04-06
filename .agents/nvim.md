# Neovim

## Layout

Configuration lives under [`.config/nvim/`](../.config/nvim/). It is based on a **modular kickstart-style** setup (multi-file Lua), documented in [`.config/nvim/README.md`](../.config/nvim/README.md).

## Expectations for agents

- Target **Neovim stable** (and optionally nightly) as described in that README.
- External tools commonly expected: `git`, `make`, `unzip`, a C compiler, **ripgrep**, **fd**, clipboard integration, and optionally a **Nerd Font** (see README table and install recipes).

## Plugins and `pack/`

Neovim can load plugins from `pack/*/start/` (native package layout). This repository may have a **`pack/`** tree (e.g. cloned plugins) that is **not** always tracked in git—policy is environment-specific (submodules, generated trees, or local-only clones).

Before adding or committing plugin trees:

- Prefer the workflow already used in this repo (plugin manager vs vendored `pack/`).
- Avoid committing large binary or generated trees without an explicit decision; align with [`.gitignore`](../.gitignore) and user intent.

## Dotfiles integration

Neovim is deployed with the rest of the tree via **stow**; paths follow XDG (`~/.config/nvim`). Changes should remain consistent with [`setup-and-scripts.md`](setup-and-scripts.md).
