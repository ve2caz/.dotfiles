# .dotfiles
This directory contains the dotfiles for a development shell environment that works on both MacOS and Linux.

## Features

This configuration includes modern CLI tools for enhanced productivity:

### File Navigation & Management
- `eza` - Modern replacement for `ls` with colors and git integration
- `fd` - Simple, fast alternative to `find`
- `yazi` - Blazing fast terminal file manager
- `zoxide` - Smart cd command that learns your habits

### Text Processing & Search
- `bat` - Clone of `cat` with syntax highlighting
- `fzf` - Command-line fuzzy finder
- `ripgrep` - Extremely fast text search tool
- `jq` - Lightweight JSON processor
- `yq` - Process YAML, JSON, XML, CSV documents

### Git Workflow
- `git-delta` - Syntax-highlighting pager for git and diff output
- `lazygit` - Simple terminal UI for git commands
- `gh` - GitHub command-line tool

### System Monitoring & Management
- `btop` - Resource monitor (htop alternative)
- `htop` - Interactive process viewer
- `tmux` - Terminal multiplexer

### Development Tools
- `neovim` - Modern Vim-based text editor
- `k9s` - Kubernetes CLI management tool
- `kubie` - Alternative to kubectx and kubens
- `lazydocker` - Simple terminal UI for Docker

### Network & Security
- `nmap` - Network discovery and security auditing
- `ipcalc` - Network address calculator

### Productivity & Fun
- `thefuck` - Corrects errors in previous console commands
- `tlrc` - Fast tldr client for quick command help
- `wezterm` - GPU-accelerated terminal emulator

## Instructions

- [Requirements](doc/requirements.md) for platform-specific setup instructions.

- [Setup Guide](doc/setup.md) for complete installation and configuration instructions.

## Key Bindings

This shell configuration provides comprehensive key bindings for efficient command line usage:

- **[zsh key bindings](doc/zsh-keybindings.md)** - Emacs-style key bindings for command line editing
- **[tmux key bindings](doc/tmux-keybindings.md)** - Terminal multiplexer shortcuts for session, window, and pane management
- **[fzf key bindings](doc/fzf-keybindings.md)** - Fuzzy finder shortcuts for files, directories, and command history
- **[fzf-git key bindings](doc/fzf-git-keybindings.md)** - Interactive Git operations with fzf integration
