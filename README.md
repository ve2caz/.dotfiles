# .dotfiles
This directory contains the dotfiles for a basic dev environment that works on both macOS and Linux.

## Requirements

### macOS

#### XCode CLI tools

This will install the developer CLI tools including git.
Homebrew depends on some of these tools!

```zsh
xcode-select --install
```

#### Homebrew

This is a popular package manager for macOS.
The following command will open a browser to this site.
Follow the instructions to install homebrew.

```
open -a "Safari" "https://brew.sh"
```

### Linux

Most distributions come with git pre-installed. If not:

```bash
# Ubuntu/Debian
sudo apt update && sudo apt install git

# RHEL/CentOS/Fedora
sudo yum install git
# or
sudo dnf install git

# Arch Linux
sudo pacman -S git
```

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
./install-packages.sh
```

### Manual installation

#### macOS with Homebrew

```bash
brew bundle
```

#### Linux

The `install-packages.sh` script handles Linux package installation automatically, but if you prefer manual installation, here are the main packages needed:

- **Core tools**: `curl git neovim stow tmux tree fzf bat`
- **Special installations**: `eza`, `zoxide`, `thefuck`, `gh`, `lazygit`

Install with your distribution's package manager, then follow the script's logic for tools that need special installation methods.

## Activate the configuration

From the .dotfiles folder, use GNU stow to create symlinks activating the configuration:

```bash
stow .
```

## What works cross-platform

- ✅ Zsh configuration with Zinit plugin manager
- ✅ Powerlevel10k prompt
- ✅ Modern CLI tools (eza, fzf, bat, zoxide, etc.)
- ✅ Color schemes and completions
- ✅ Key bindings and aliases
- ✅ Smart fallbacks for GNU/BSD tool differences

## Platform-specific features

- **macOS**: Homebrew integration, newer curl from Homebrew
- **Linux**: Uses distribution package managers, native GNU tools
