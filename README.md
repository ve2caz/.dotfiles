# .dotfiles

Shell, terminal and Neovim configuration for macOS, with zsh and Homebrew, deployed with GNU Stow.

## New Mac

```zsh
xcode-select --install
```

Install Homebrew from https://brew.sh, then:

```zsh
git clone https://github.com/ve2caz/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./scripts/setup.sh
./scripts/doctor.sh
```

`setup.sh` is safe to rerun. `doctor.sh` must report no problems.

## Cheat sheets

- [zsh startup files](docs/zsh-shell-primer.md)
- [zsh key bindings](docs/zsh-keybindings.md)
- [fzf key bindings](docs/fzf-keybindings.md)
- [fzf-git key bindings](docs/fzf-git-keybindings.md)
