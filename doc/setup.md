# Setup Guide

## 🚀 Quick Setup (Recommended)

For a complete automated installation, use the master setup script:

```bash
# Clone the repository
git clone https://github.com/ve2caz/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Run the master setup script (installs everything)
./scripts/setup.sh
```

This master script will:
- Install all required packages via `install-packages.sh`
- Activate the configuration using GNU Stow
- Set up the Tokyo Night theme across all tools
- Provide final setup instructions

## Manual Setup (Advanced Users)

If you prefer to control each step individually, follow these manual instructions:

### 1. Deploy the shell configuration

First, check out the .dotfiles repo in your $HOME directory using git

```bash
cd ~
git clone git@github.com/ve2caz/.dotfiles.git
cd .dotfiles
```

### 2. Install packages

#### Automated installation (recommended)

Use the cross-platform installer script:

```bash
./scripts/install-packages.sh
```

To verify what's installed, you can run:

```bash
./scripts/check-installation.sh
```

### Script Dependencies

The setup process follows this dependency structure:

```
setup.sh (master)
├── install-packages.sh
│   ├── Platform detection (macOS/Linux)
│   ├── Package installation (brew/apt)
│   ├── Font installation
│   └── Tool setup (Zinit, TPM, fzf-git)
├── stow . --target=$HOME
├── setup-tokyo-night-theme.sh
    ├── Bat theme download
    ├── Yazi flavor verification
    └── Theme consistency checks
└── setup-asdf-plugins.sh
    └── Install asdf plugins
```

#### Manual installation

##### macOS with Homebrew

```bash
brew bundle
```

##### Linux (Debian/Ubuntu only)

The `scripts/install-packages.sh` script handles Linux package installation automatically for Debian/Ubuntu-based systems. For other distributions, manual installation is not supported by this repo.

If you prefer manual installation on Debian/Ubuntu, see the script for the list of required packages and GitHub releases used.

### 3. Activate the configuration

From the .dotfiles folder, use GNU stow to create symlinks activating the configuration:

```bash
stow .
```

### 4. Set up Tokyo Night theme (Optional)

To apply the consistent Tokyo Night theme across all tools:

```bash
./scripts/setup-tokyo-night-theme.sh
```

## What works cross-platform

- ✅ Zsh configuration with Zinit plugin manager
- ✅ Starship prompt
- ✅ Modern CLI tools (eza, fzf, bat, fd, zoxide, yazi, etc.)
- ✅ Color schemes and completions (asdf completions in `~/.asdf/completions`)
- ✅ Key bindings and aliases
- ✅ Smart fallbacks for GNU/BSD tool differences
- ✅ XDG Base Directory Specification compliance

## XDG Base Directory Compliance

This configuration follows the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) to keep your home directory clean, with the exception of asdf, which is installed to `~/.asdf` as per official recommendations:

- **Config files**: `$XDG_CONFIG_HOME` (default: `~/.config`)
- **Data files**: `$XDG_DATA_HOME` (default: `~/.local/share`)
- **Cache files**: `$XDG_CACHE_HOME` (default: `~/.cache`)
- **asdf**: installed to `~/.asdf` and completions in `~/.asdf/completions` (official method)

Key XDG improvements:
- All themes and data properly organized in XDG directories
- Starship config in `$XDG_CONFIG_HOME/starship.toml`
- Zsh history moved to `$XDG_STATE_HOME/zsh/history`

### Directory Organization

| Variable | Default | Purpose |
|----------|---------|---------|
| `$XDG_CACHE_HOME` | `~/.cache` | Temporary cache files |
| `$XDG_CONFIG_HOME` | `~/.config` | User configuration files |
| `$XDG_DATA_HOME` | `~/.local/share` | Application data, plugins, fonts |
| `$XDG_STATE_HOME` | `~/.local/state` | State files, logs, history |

### Lifecycle & Fallbacks

This project is designed to run in two phases:

1. **First Run (Bootstrap)** — Before environment is configured
   - Scripts source `~/.zsh-xdg-base-dirs` if it exists
   - If unavailable, scripts use inline fallbacks: `${XDG_VAR:-default}`
   - Ensures scripts work on fresh systems without pre-existing configuration
   - The `.zsh-xdg-base-dirs` file is created by `install-packages.sh`

2. **Subsequent Runs (Maintenance)** — After environment setup
   - `.zshenv` sources `~/.zsh-xdg-base-dirs` early, exporting all XDG variables
   - All shell configuration and scripts see properly set XDG paths
   - Scripts remain idempotent and can re-run safely at any time

### Fallback Policy

- **Shell configuration** (`.zshenv`, `.zshrc`) — Assumes XDG variables are set (post-setup)
- **Installation scripts** (`install-packages.sh`, etc.) — Use `${XDG_VAR:-fallback}` for robustness
- **Setup & configuration scripts** (`setup-*.sh`) — Define XDG variables explicitly to work pre- and post-setup

This dual-phase approach allows the dotfiles to work cleanly from a fresh clone while remaining maintainable and idempotent on configured systems.

## Included Tools

For a complete list of all the modern command-line tools included in this configuration, see **[Included Tools](tools.md)**.

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

### On Linux (Debian/Ubuntu only):
- Install packages via apt
- Install asdf via git clone to `~/.asdf` (official method)
- Download and install tools not available in repos (from GitHub releases)
- Install Nerd Fonts to user font directory
- Optionally install GitHub Desktop via third-party repository

**Note**:
- Completions: Generated to `~/.asdf/completions/_asdf` (both platforms)

### asdf plugins installed by setup-asdf-plugins.sh

The setup process installs the following `asdf` plugins:

- ctlptl
- golang
- gradle
- helm
- java
- kind
- kotlin
- krew
- kubebuilder
- kubectl
- maven
- mockery
- nodejs
- python
- rancher
- rust
- step
- tilt

## 🔧 Maintenance and Troubleshooting

### Individual Script Usage

**For new setups**: Use `./scripts/setup.sh` - it handles everything automatically.

**For maintenance**: Run individual scripts as needed:
- `./scripts/check-installation.sh` - Check what's installed and verify tool availability
- `./scripts/setup-tokyo-night-theme.sh` - Re-apply themes across all tools
- `./scripts/install-packages.sh` - Update or install missing packages

**For troubleshooting**: All scripts are designed to be idempotent (safe to run multiple times) and provide clear error messages for missing dependencies.

### Installation Verification

Use the verification script to check your installation status:

```bash
./scripts/check-installation.sh
```

This script verifies that all tools are properly installed and checks:
- Core tools availability (git, neovim, stow, tmux, etc.)
- Modern CLI tools installation (eza, fzf, bat, fd, etc.) 
- Development tools functionality (gh, lazygit, delta, etc.)
- System tools (btop, yq, k9s, etc.)
- Font installation status (MesloLG Nerd Font, Symbols Only)
- Tmux plugin manager (TPM) setup
