# .dotfiles
This directory contains the dotfiles for a development shell environment that works on both macOS and Debian/Ubuntu Linux.

## 🚀 Quick Setup

```zsh
# Clone the repository
git clone https://github.com/ve2caz/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Run the master setup script (installs everything)
./scripts/setup.sh
```

## �️ What's Included

This configuration includes modern command-line tools across these categories:

- **Core Development Tools** - git, neovim, GitHub CLI, and more
- **Container & Kubernetes Management** - k9s, kubie, lazydocker
- **File & Directory Navigation** - eza, fd, tree, yazi, zoxide
- **Text Processing & Search** - bat, fzf, ripgrep, jq, yq
- **System Monitoring & Utilities** - btop, htop, nmap, imagemagick
- **Terminal & Productivity** - tmux, thefuck, wezterm
- **Fonts & Typography** - MesloLG Nerd Font and more

See **[Included Tools](docs/tools.md)** for the complete list of modern command-line tools included in this configuration

## 📚 Documentation

- **[ZSH Shell Primer](docs/zsh-shell-primer.md)** - Introduction to ZSH shell fundamentals and best practices
- **[Requirements](docs/requirements.md)** - Platform-specific prerequisites and dependencies
- **[Setup Guide](docs/setup.md)** - Complete installation, configuration, maintenance, and troubleshooting instructions
- **[Cross-Platform Tools](docs/cross-platform-tools.md)** - How macOS Brewfile tools are installed on Linux
- **[Tokyo Night Theme](docs/tokyo-night-theme.md)** - Unified dark theme configuration across all tools

## ⌨️ Key Bindings

Comprehensive key bindings for efficient command line usage:

- **[zsh key bindings](docs/zsh-keybindings.md)** - Emacs-style key bindings for command line editing
- **[tmux key bindings](docs/tmux-keybindings.md)** - Terminal multiplexer shortcuts for session, window, and pane management
- **[fzf key bindings](docs/fzf-keybindings.md)** - Fuzzy finder shortcuts for files, directories, and command history
- **[fzf-git key bindings](docs/fzf-git-keybindings.md)** - Interactive Git operations with fzf integration
