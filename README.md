# .dotfiles
This directory contains the dotfiles for a development shell environment that works on both macOS and Linux.

## Key Bindings

### Zsh Key Bindings (Emacs-style)

| Category | Key Binding | Description |
|-----------|-------------|-------------|
| **Navigation** | `CTRL-A` | Move cursor to beginning of line |
|  | `CTRL-E` | Move cursor to end of line |
|  | `CTRL-B` | Move cursor backward one character |
|  | `CTRL-F` | Move cursor forward one character |
|  | `ALT-B` | Move cursor backward one word |
|  | `ALT-F` | Move cursor forward one word |
| **Deletion** | `CTRL-D` | Delete character under cursor |
|  | `CTRL-H` | Delete character before cursor (backspace) |
|  | `ALT-D` | Delete word forward |
|  | `ALT-Backspace` | Delete word backward |
| **Kill & Yank** | `CTRL-K` | Kill (cut) from cursor to end of line |
|  | `CTRL-U` | Kill (cut) from cursor to beginning of line |
|  | `CTRL-Y` | Yank (paste) most recently killed text |
|  | `ALT-Y` | Cycle through kill ring (after CTRL-Y) |
|  | `ALT-W` | Cut/kill selected region (custom) |
| **Text Manipulation** | `CTRL-T` | Transpose characters |
|  | `ALT-T` | Transpose words |
| **Search & Control** | `CTRL-R` | Reverse incremental search |
|  | `CTRL-S` | Forward incremental search |
|  | `CTRL-P` | Search backward in command history (custom) |
|  | `CTRL-N` | Search forward in command history (custom) |
|  | `CTRL-G` | Cancel current operation |
|  | `CTRL-L` | Clear screen |

### fzf (command line fuzzy finder)

| Category | Key Binding | Description |
|-----------|-------------|-------------|
| **File Search** | `CTRL-T` | Look for files and directories |
| **History Search** | `CTRL-R` | Look through command history |
| **Selection** | `Enter` | Select the item |
| **Navigation** | `Ctrl-j` or `Ctrl-n` or `Down arrow` | Go down one result |
|  | `Ctrl-k` or `Ctrl-p` or `Up arrow` | Go up one result |
| **Marking** | `Tab` | Mark a result |
|  | `Shift-Tab` | Unmark a result |
| **Completion** | `cd **Tab` | Open up fzf to find directory |
|  | `export **Tab` | Look for env variable to export |
|  | `unset **Tab` | Look for env variable to unset |
|  | `unalias **Tab` | Look for alias to unalias |
|  | `ssh **Tab` | Look for recently visited host names |
|  | `kill -9 **Tab` | Look for process name to kill to get pid |
|  | `any command + **Tab` | Look for files & directories to complete command |

### fzf-git (interactive Git operations with fzf)

| Category | Key Binding | Description |
|-----------|-------------|-------------|
| **Git Files** | `CTRL-GF` | Look for git files with fzf |
| **Git Branches** | `CTRL-GB` | Look for git branches with fzf |
| **Git Tags** | `CTRL-GT` | Look for git tags with fzf |
| **Git Remotes** | `CTRL-GR` | Look for git remotes with fzf |
| **Git History** | `CTRL-GH` | Look for git commit hashes with fzf |
| **Git Stash** | `CTRL-GS` | Look for git stashes with fzf |
| **Git Logs** | `CTRL-GL` | Look for git reflogs with fzf |
| **Git Worktrees** | `CTRL-GW` | Look for git worktrees with fzf |
| **Git References** | `CTRL-GE` | Look for git for-each-ref with fzf |

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
