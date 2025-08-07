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

To verify what's installed, you can run:

```bash
./scripts/check-installation.sh
```

### Manual installation

#### MacOS with Homebrew

```bash
brew bundle
```

#### Linux

The `scripts/install-packages.sh` script handles Linux package installation automatically, but if you prefer manual installation, here are the main packages needed:

- **Core tools**: `curl git neovim stow tmux tree fzf bat fd-find htop imagemagick jq nmap ripgrep p7zip-full openssl`
- **Special installations**: `eza`, `zoxide`, `thefuck`, `gh`, `lazygit`, `git-delta`, `tlrc`, `tpm`, `yazi`, `wezterm`, `btop`, `yq`, `k9s`, `kubie`, `lazydocker`
- **Fonts**: `MesloLG Nerd Font`, `Symbols Only Nerd Font` (installed to `~/.local/share/fonts`)
- **GUI Applications**: `GitHub Desktop` (optional)

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

### Container and Kubernetes Management
- **k9s** - Kubernetes CLI to manage clusters in style
- **kubie** - Powerful alternative to kubectx and kubens
- **lazydocker** - Simple terminal UI for Docker management

### File and Directory Navigation
- **eza** - Modern replacement for `ls` with colors and icons
- **fd** - Simple, fast alternative to `find`
- **tree** - Display directories as trees
- **yazi** - Blazing fast terminal file manager written in Rust
- **zoxide** - Smart cd command that learns your habits

### Text Processing and Search
- **bat** - Clone of `cat` with syntax highlighting and Git integration
- **fzf** - Command-line fuzzy finder for files, directories, and history
- **ripgrep** - Extremely fast text search tool
- **jq** - Lightweight JSON processor
- **yq** - Process YAML, JSON, XML, CSV and properties documents
- **tlrc** - Official tldr client for community-maintained help pages (use `tldr <command>`)

### System Monitoring and Utilities
- **btop** - Resource monitor (modern alternative to htop)
- **htop** - Interactive process viewer
- **nmap** - Network discovery and security auditing utility
- **ipcalc** - Calculate various network masks from IP addresses
- **imagemagick** - Tools and libraries to manipulate images
- **sevenzip** (p7zip-full on Linux) - File archiver with high compression ratio
- **poppler-utils** (Linux) - PDF rendering utilities

### Terminal and Productivity
- **tmux** - Terminal multiplexer for session management
- **tpm** - Plugin manager for tmux
- **thefuck** - Corrects mistyped console commands
- **wezterm** - GPU-accelerated cross-platform terminal emulator

### Fonts and Typography
- **MesloLG Nerd Font** - Patched font with programming symbols and icons
- **Symbols Only Nerd Font** - Icon font for terminal and status line symbols

### GUI Applications (Linux)
- **GitHub Desktop** - Desktop client for GitHub repositories (optional)

### System Utilities
- **curl** - Tool for transferring data from servers
- **stow** - Symlink farm manager for organizing dotfiles  
- **openssl** - Cryptography and SSL/TLS toolkit
- **coreutils** - GNU File, Shell, and Text utilities (macOS via Homebrew)

## Platform-specific features

- **macOS**: Homebrew integration, newer curl from Homebrew, macOS-specific fonts via casks
- **Linux**: Uses distribution package managers, native GNU tools, automatic Nerd Font installation to `~/.local/share/fonts`

## Automatic vs Manual Installation

The automated installation script (`./scripts/install-packages.sh`) will:

### On all platforms:
- Verify and install `zsh` if missing
- Install all core command-line tools
- Set up tmux plugin manager (tpm)
- Create necessary directories and symlinks

### On macOS:
- Use `brew bundle` to install packages from Brewfile
- Install cask applications (fonts, GitHub Desktop, WezTerm)

### On Linux:
- Install packages via distribution package manager (apt/yum/pacman)
- Download and install tools not available in repos (from GitHub releases)
- Install Nerd Fonts to user font directory
- Optionally install GitHub Desktop via third-party repository

**Note**: Full automation is available for Debian/Ubuntu systems. RHEL/CentOS/Fedora and Arch Linux have basic support with core packages only.
