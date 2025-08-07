# .dotfiles
This directory contains the dotfiles for a development shell environment that works on both MacOS and Linux.

## 🚀 Quick Setup

```bash
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

See **[Included Tools](doc/tools.md)** for the complete list of modern command-line tools included in this configuration

## 📚 Documentation

- **[Requirements](doc/requirements.md)** - Platform-specific prerequisites and dependencies
- **[Setup Guide](doc/setup.md)** - Complete installation, configuration, maintenance, and troubleshooting instructions
- **[Cross-Platform Tools](doc/cross-platform-tools.md)** - How MacOS Brewfile tools are installed on Linux
- **[Tokyo Night Theme](doc/tokyo-night-theme.md)** - Unified dark theme configuration across all tools

## ⌨️ Key Bindings

Comprehensive key bindings for efficient command line usage:

- **[zsh key bindings](doc/zsh-keybindings.md)** - Emacs-style key bindings for command line editing
- **[tmux key bindings](doc/tmux-keybindings.md)** - Terminal multiplexer shortcuts for session, window, and pane management
- **[fzf key bindings](doc/fzf-keybindings.md)** - Fuzzy finder shortcuts for files, directories, and command history
- **[fzf-git key bindings](doc/fzf-git-keybindings.md)** - Interactive Git operations with fzf integration
