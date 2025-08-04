# .dotfiles
This directory contains the dotfiles for a development shell environment that works on both macOS and Linux.

## Key Bindings

### fzf (command line fuzzy finder)

| Key Binding | Description |
|-------------|-------------|
| `CTRL-t` | Look for files and directories |
| `CTRL-r` | Look through command history |
| `Enter` | Select the item |
| `Ctrl-j` or `Ctrl-n` or `Down arrow` | Go down one result |
| `Ctrl-k` or `Ctrl-p` or `Up arrow` | Go up one result |
| `Tab` | Mark a result |
| `Shift-Tab` | Unmark a result |
| `cd **Tab` | Open up fzf to find directory |
| `export **Tab` | Look for env variable to export |
| `unset **Tab` | Look for env variable to unset |
| `unalias **Tab` | Look for alias to unalias |
| `ssh **Tab` | Look for recently visited host names |
| `kill -9 **Tab` | Look for process name to kill to get pid |
| `any command + **Tab` | Look for files & directories to complete command |

### fzf-git (interactive Git operations with fzf)

| Key Binding | Description |
|-------------|-------------|
| `CTRL-GF` | Look for git files with fzf |
| `CTRL-GB` | Look for git branches with fzf |
| `CTRL-GT` | Look for git tags with fzf |
| `CTRL-GR` | Look for git remotes with fzf |
| `CTRL-GH` | Look for git commit hashes with fzf |
| `CTRL-GS` | Look for git stashes with fzf |
| `CTRL-GL` | Look for git reflogs with fzf |
| `CTRL-GW` | Look for git worktrees with fzf |
| `CTRL-GE` | Look for git for-each-ref with fzf |

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
