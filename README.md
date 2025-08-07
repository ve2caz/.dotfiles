# .dotfiles
This directory contains the dotfiles for a development shell environment that works on both MacOS and Linux.

## Features

This configuration includes modern CLI tools for enhanced productivity:

### File Navigation & Management
- [`eza`](https://github.com/eza-community/eza) - Modern replacement for `ls` with colors and git integration
- [`fd`](https://github.com/sharkdp/fd) - Simple, fast alternative to `find`
- [`yazi`](https://yazi-rs.github.io/) - Blazing fast terminal file manager
- [`zoxide`](https://github.com/ajeetdsouza/zoxide) - Smart cd command that learns your habits

### Text Processing & Search
- [`bat`](https://github.com/sharkdp/bat) - Clone of `cat` with syntax highlighting
- [`fzf`](https://github.com/junegunn/fzf) - Command-line fuzzy finder
- [`ripgrep`](https://github.com/BurntSushi/ripgrep) - Extremely fast text search tool
- [`jq`](https://jqlang.github.io/jq/) - Lightweight JSON processor
- [`yq`](https://github.com/mikefarah/yq) - Process YAML, JSON, XML, CSV documents

### Git Workflow
- [`git-delta`](https://github.com/dandavison/delta) - Syntax-highlighting pager for git and diff output
- [`lazygit`](https://github.com/jesseduffield/lazygit) - Simple terminal UI for git commands
- [`gh`](https://github.com/cli/cli) - GitHub command-line tool

### System Monitoring & Management
- [`btop`](https://github.com/aristocratos/btop) - Resource monitor (htop alternative)
- [`htop`](https://github.com/htop-dev/htop) - Interactive process viewer
- [`tmux`](https://github.com/tmux/tmux) - Terminal multiplexer

### Development Tools
- [`neovim`](https://neovim.io/) - Modern Vim-based text editor
- [`k9s`](https://k9scli.io/) - Kubernetes CLI management tool
- [`kubie`](https://github.com/sbstp/kubie) - Alternative to kubectx and kubens
- [`lazydocker`](https://github.com/jesseduffield/lazydocker) - Simple terminal UI for Docker

### Network & Security
- [`nmap`](https://nmap.org/) - Network discovery and security auditing
- [`ipcalc`](https://github.com/kjokjo/ipcalc) - Network address calculator

### Productivity & Fun
- [`thefuck`](https://github.com/nvbn/thefuck) - Corrects errors in previous console commands
- [`tlrc`](https://github.com/tldr-pages/tlrc) - Fast tldr client for quick command help
- [`wezterm`](https://wezfurlong.org/wezterm/) - GPU-accelerated terminal emulator

## Instructions

- [Requirements](doc/requirements.md) for platform-specific setup instructions.

- [Setup Guide](doc/setup.md) for complete installation and configuration instructions.

- [Cross-Platform Tools](doc/cross-platform-tools.md) for details on how macOS Brewfile tools are installed on Linux.

## Key Bindings

This shell configuration provides comprehensive key bindings for efficient command line usage:

- **[zsh key bindings](doc/zsh-keybindings.md)** - Emacs-style key bindings for command line editing
- **[tmux key bindings](doc/tmux-keybindings.md)** - Terminal multiplexer shortcuts for session, window, and pane management
- **[fzf key bindings](doc/fzf-keybindings.md)** - Fuzzy finder shortcuts for files, directories, and command history
- **[fzf-git key bindings](doc/fzf-git-keybindings.md)** - Interactive Git operations with fzf integration
