# Cross-Platform Tool Installation

This document details how tools from the MacOS `Brewfile` are installed on Linux systems.

## Package Installation Methods

### Brewfile Tools → Linux Installation

| MacOS (Homebrew) | Linux Installation Method | Notes |
|------------------|---------------------------|--------|
| `brew "openssl@3"` | `apt install openssl` | System package (usually pre-installed) |
| `brew "bat"` | `apt install bat` | System package |
| `brew "btop"` | GitHub Releases | Downloaded as pre-compiled binary |
| `brew "coreutils"` | Native | GNU coreutils included by default on Linux |
| `brew "curl"` | `apt install curl` | System package |
| `brew "eza"` | Custom repo | Added via third-party deb repository |
| `brew "fd"` | `apt install fd-find` | System package (symlinked to `fd`) |
| `brew "ffmpegthumbnailer"` | `apt install ffmpegthumbnailer` | System package |
| `brew "fzf"` | `apt install fzf` | System package |
| `brew "gh"` | GitHub official repo | Added via official GitHub CLI repository |
| `brew "git"` | `apt install git` | System package |
| `brew "git-delta"` | GitHub Releases | Downloaded as deb package |
| `brew "htop"` | `apt install htop` | System package |
| `brew "imagemagick"` | `apt install imagemagick` | System package |
| `brew "ipcalc"` | `apt install ipcalc` | System package |
| `brew "jq"` | `apt install jq` | System package |
| `brew "k9s"` | GitHub Releases | Downloaded as pre-compiled binary |
| `brew "kubie"` | GitHub Releases | Downloaded as pre-compiled binary |
| `brew "lazydocker"` | GitHub Releases | Downloaded as pre-compiled binary |
| `brew "lazygit"` | GitHub Releases | Downloaded as pre-compiled binary |
| `brew "neovim"` | `apt install neovim` | System package |
| `brew "nmap"` | `apt install nmap` | System package |
| `brew "poppler"` | `apt install poppler-utils` | System package (utilities only) |
| `brew "ripgrep"` | `apt install ripgrep` | System package |
| `brew "sevenzip"` | `apt install p7zip-full` | System package (different name) |
| `brew "stow"` | `apt install stow` | System package |
| `brew "direnv"` | `apt install direnv` | System package |
| `brew "thefuck"` | `pip3 install --user thefuck` | Python package |
| `brew "tlrc"` | GitHub Releases | Downloaded as pre-compiled binary |
| `brew "tmux"` | `apt install tmux` | System package |
| `brew "tpm"` | Git clone | Cloned to tmux plugins directory |
| `brew "tree"` | `apt install tree` | System package |
| `brew "yazi"` | GitHub Releases | Downloaded as pre-compiled binary |
| `brew "yq"` | GitHub Releases | Downloaded as pre-compiled binary |
| `brew "zoxide"` | Install script | Installed via official install script |

### Cask Applications → Linux Alternatives

| MacOS (Homebrew Cask) | Linux Installation | Notes |
|------------------------|-------------------|--------|
| `cask "font-meslo-lg-nerd-font"` | Download from Nerd Fonts | Installed to `~/.local/share/fonts` |
| `cask "font-symbols-only-nerd-font"` | Download from Nerd Fonts | Installed to `~/.local/share/fonts` |
| `cask "github"` | Third-party repo | GitHub Desktop via shiftkey repository |
| `cask "wezterm"` | Official repo | Added via official WezTerm repository |

## Installation Strategy

The Linux installation prioritizes:

1. **System packages** when available and up-to-date
2. **Official repositories** from tool maintainers
3. **GitHub Releases** for tools not in system repos
4. **Third-party repos** for specialized tools
5. **Install scripts** when provided by maintainers
6. **Python pip** for Python-based tools

## Font Installation

Fonts on Linux are installed to `~/.local/share/fonts/` and the font cache is updated with `fc-cache -fv`. This makes them available to all applications for the current user.

## Distribution Support

The current script supports:
- **Debian/Ubuntu**: Full support with `apt` package manager
- **RHEL/CentOS/Fedora**: Basic support with `yum`/`dnf` (core packages only)
- **Arch Linux**: Basic support with `pacman` (core packages only)

### Full vs Basic Support

**Full Support (Debian/Ubuntu):**
- All core system packages
- Third-party repositories for specialized tools
- GitHub releases for latest versions
- Automatic font installation
- GUI applications

**Basic Support (RHEL/Arch):**
- Core system packages only
- Manual installation required for specialized tools
- Suggestions provided for package manager alternatives (AUR, EPEL, etc.)

Additional distributions can be added by implementing the respective package manager logic in the installation script. Contributions welcome!
