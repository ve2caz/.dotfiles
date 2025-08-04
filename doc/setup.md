# Setup Guide

## Deploy the shell configuration

First, check out the .dotfiles repo in your $HOME directory using git

```bash
cd ~
git clone git@github.com/ve2caz/.dotfiles.git
cd .dotfiles
```

## Install packages

### Automated installation (recommended)

Use the cross-platform installer script:

```bash
./scripts/install-packages.sh
```

### Manual installation

#### MacOS with Homebrew

```bash
brew bundle
```

#### Linux

The `scripts/install-packages.sh` script handles Linux package installation automatically, but if you prefer manual installation, here are the main packages needed:

- **Core tools**: `curl git neovim stow tmux tree fzf bat fd-find`
- **Special installations**: `eza`, `zoxide`, `thefuck`, `gh`, `lazygit`, `git-delta`, `tlrc`, `tpm`, `yazi`, `wezterm`

Install with your distribution's package manager, then follow the script's logic for tools that need special installation methods.

## Activate the configuration

From the .dotfiles folder, use GNU stow to create symlinks activating the configuration:

```bash
stow .
```

## What works cross-platform

- ✅ Zsh configuration with Zinit plugin manager
- ✅ Powerlevel10k prompt
- ✅ Modern CLI tools (eza, fzf, bat, fd, zoxide, yazi, etc.)
- ✅ Color schemes and completions
- ✅ Key bindings and aliases
- ✅ Smart fallbacks for GNU/BSD tool differences

## Included Tools

This dotfiles configuration includes a curated set of modern command-line tools:

### Core Development Tools
- **git** - Distributed version control system
- **git-delta** - Syntax-highlighting pager for git and diff output (pre-configured in `.gitconfig`)
- **gh** - GitHub command-line tool for repository management
- **lazygit** - Simple terminal UI for git commands
- **neovim** - Modern, extensible text editor

### File and Directory Navigation
- **eza** - Modern replacement for `ls` with colors and icons
- **fd** - Simple, fast alternative to `find`
- **tree** - Display directories as trees
- **yazi** - Blazing fast terminal file manager written in Rust
- **zoxide** - Smart cd command that learns your habits

### Text Processing and Search
- **bat** - Clone of `cat` with syntax highlighting and Git integration
- **fzf** - Command-line fuzzy finder for files, directories, and history
- **tlrc** - Official tldr client for community-maintained help pages (use `tldr <command>`)

### Terminal and Productivity
- **tmux** - Terminal multiplexer for session management
- **tpm** - Plugin manager for tmux
- **thefuck** - Corrects mistyped console commands
- **wezterm** - GPU-accelerated cross-platform terminal emulator

### System Utilities
- **curl** - Tool for transferring data from servers
- **stow** - Symlink farm manager for organizing dotfiles
- **coreutils** - GNU File, Shell, and Text utilities (macOS via Homebrew)

## Platform-specific features

- **macOS**: Homebrew integration, newer curl from Homebrew
- **Linux**: Uses distribution package managers, native GNU tools
