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
│   ├── Package installation (brew/apt/yum/pacman)
│   ├── Font installation
│   └── Tool setup (Zinit, TPM, fzf-git)
├── stow . --target=$HOME
└── setup-tokyo-night-theme.sh
    ├── Bat theme download
    ├── Yazi flavor verification
    └── Theme consistency checks
```

#### Manual installation

##### MacOS with Homebrew

```bash
brew bundle
```

##### Linux

The `scripts/install-packages.sh` script handles Linux package installation automatically, but if you prefer manual installation, here are the main packages needed:

- **Core tools**: `curl git neovim stow tmux tree fzf bat fd-find htop imagemagick jq nmap ripgrep p7zip-full openssl`
- **Special installations**: `eza`, `zoxide`, `thefuck`, `gh`, `lazygit`, `git-delta`, `tlrc`, `tpm`, `yazi`, `wezterm`, `btop`, `yq`, `k9s`, `kubie`, `lazydocker`
- **Fonts**: `MesloLG Nerd Font`, `Symbols Only Nerd Font` (installed to `~/.local/share/fonts`)
- **GUI Applications**: `GitHub Desktop` (optional)

Install with your distribution's package manager, then follow the script's logic for tools that need special installation methods.

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
- ✅ Powerlevel10k prompt
- ✅ Modern CLI tools (eza, fzf, bat, fd, zoxide, yazi, etc.)
- ✅ Color schemes and completions
- ✅ Key bindings and aliases
- ✅ Smart fallbacks for GNU/BSD tool differences

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

### On Linux:
- Install packages via distribution package manager (apt/yum/pacman)
- Download and install tools not available in repos (from GitHub releases)
- Install Nerd Fonts to user font directory
- Optionally install GitHub Desktop via third-party repository

**Note**: Full automation is available for Debian/Ubuntu systems. RHEL/CentOS/Fedora and Arch Linux have basic support with core packages only.

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
