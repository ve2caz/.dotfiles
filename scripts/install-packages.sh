#!/bin/bash
# Cross-platform package installer script
#
# Note: Using bash instead of zsh for maximum compatibility during initial setup.
# This script runs before zsh configuration is deployed, so bash ensures it works
# on fresh systems where zsh might not be the default shell yet. Bash is guaranteed
# to be available on MacOS and virtually all Linux distributions out of the box.

# Ensure script exits on error
set -e

# XDG Base Directory Specification (externalized)
_XDG_BASE_DIRS_FILE="$HOME/.zsh-xdg-base-dirs"
if [ -f "$_XDG_BASE_DIRS_FILE" ]; then
    source "$_XDG_BASE_DIRS_FILE"
fi

# Detect operating system
OS="$(uname -s)"
DISTRO=""

if [[ "$OS" == "Linux" ]]; then
    # Detect Linux distribution
    if command -v apt >/dev/null 2>&1; then
        DISTRO="debian"
    else
        echo "Unsupported Linux distribution. Only Debian/Ubuntu-based systems are supported."
        echo "Please use a Debian/Ubuntu-based distribution or install packages manually."
        exit 1
    fi
fi

echo "Detected OS: $OS"
[[ -n "$DISTRO" ]] && echo "Detected distribution: $DISTRO"

# Ensure zsh is installed (required for dotfiles configuration)
if ! command -v zsh >/dev/null 2>&1; then
    echo "Zsh not found. Installing zsh..."
    case "$OS" in
        Darwin)
            # MacOS has zsh as default since 10.15 (Catalina, 2019)
            echo "ERROR: Zsh not found on MacOS. This is unexpected."
            echo "Please check your MacOS version or install zsh manually."
            exit 1
            ;;
        Linux)
            case "$DISTRO" in
                debian)
                    sudo apt update && sudo apt install -y zsh
                    ;;
                *)
                    echo "ERROR: Cannot install zsh automatically on this distribution."
                    echo "Please install zsh manually with your package manager."
                    exit 1
                    ;;
            esac
            ;;
    esac
    echo "Zsh installed successfully!"
else
    echo "Zsh is already installed: $(zsh --version)"
fi

case "$OS" in
    Darwin)
        echo "Installing packages with Homebrew..."
        if ! command -v brew >/dev/null 2>&1; then
            echo "Homebrew not found. Please install it first:"
            echo 'open -a "Safari" "https://brew.sh"'
            exit 1
        fi
        brew bundle
        ;;
    Linux)
        case "$DISTRO" in
            debian)
                echo "Installing packages with apt..."
                sudo apt update
                # Install packages that are available via apt (zsh handled separately above)
                # Note: coreutils (GNU File, Shell, and Text utilities) are included by default on Linux
                sudo apt install -y curl git neovim stow tmux tree fzf bat htop imagemagick jq nmap ripgrep p7zip-full openssl direnv starship
                
                # Install packages that need special handling
                echo "Installing additional packages..."
                
                # Install Nerd Fonts (equivalents of cask fonts from MacOS)
                echo "Installing Nerd Fonts..."
                if [ ! -d "${XDG_DATA_HOME:-${HOME}/.local/share}/fonts" ]; then
                    mkdir -p "${XDG_DATA_HOME:-${HOME}/.local/share}/fonts"
                fi
                
                # Install MesloLG Nerd Font
                if [ ! -f "${XDG_DATA_HOME:-${HOME}/.local/share}/fonts/MesloLGSNerdFontMono-Regular.ttf" ]; then
                    cd /tmp
                    wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip
                    unzip -q Meslo.zip -d meslo-font
                    cp meslo-font/*.ttf "${XDG_DATA_HOME:-${HOME}/.local/share}/fonts/"
                    rm -rf Meslo.zip meslo-font
                    fc-cache -fv >/dev/null 2>&1
                    echo "MesloLG Nerd Font installed"
                fi
                
                # Install Symbols Only Nerd Font
                if [ ! -f "${XDG_DATA_HOME:-${HOME}/.local/share}/fonts/SymbolsNerdFontMono-Regular.ttf" ]; then
                    cd /tmp
                    wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.zip
                    unzip -q NerdFontsSymbolsOnly.zip -d symbols-font
                    cp symbols-font/*.ttf "${XDG_DATA_HOME:-${HOME}/.local/share}/fonts/"
                    rm -rf NerdFontsSymbolsOnly.zip symbols-font
                    fc-cache -fv >/dev/null 2>&1
                    echo "Symbols Only Nerd Font installed"
                fi
                
                # eza (modern ls replacement)
                if ! command -v eza >/dev/null 2>&1; then
                    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
                    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
                    sudo apt update
                    sudo apt install -y eza
                fi
                
                # zoxide (smart cd)
                if ! command -v zoxide >/dev/null 2>&1; then
                    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
                fi
                
                # thefuck
                if ! command -v thefuck >/dev/null 2>&1; then
                    pip3 install --user thefuck
                fi
                
                # gh (GitHub CLI)
                if ! command -v gh >/dev/null 2>&1; then
                    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
                    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
                    sudo apt update
                    sudo apt install -y gh
                fi
                
                # lazygit
                if ! command -v lazygit >/dev/null 2>&1; then
                    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
                    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
                    tar xf lazygit.tar.gz lazygit
                    sudo install lazygit /usr/local/bin
                    rm lazygit.tar.gz lazygit
                fi
                
                # fd (simple, fast alternative to find)
                if ! command -v fd >/dev/null 2>&1; then
                    sudo apt install -y fd-find
                    # Create symlink for 'fd' command (Ubuntu/Debian names it fd-find)
                    if [ ! -f ~/.local/bin/fd ]; then
                        mkdir -p ~/.local/bin
                        ln -s $(which fdfind) ~/.local/bin/fd
                    fi
                fi
                
                # asdf (version manager) - XDG compliant install
                ASDF_XDG_DATA_HOME="${XDG_DATA_HOME}/asdf"
                if [ ! -d "$ASDF_XDG_DATA_HOME" ]; then
                    echo "Installing asdf (XDG compliant) to $ASDF_XDG_DATA_HOME..."
                    git clone https://github.com/asdf-vm/asdf.git "$ASDF_XDG_DATA_HOME" --branch v0.18.0
                else
                    echo "asdf already installed at $ASDF_XDG_DATA_HOME."
                fi
                
                # yazi (terminal file manager)
                if ! command -v yazi >/dev/null 2>&1; then
                    # Install from GitHub releases
                    YAZI_VERSION=$(curl -s "https://api.github.com/repos/sxyazi/yazi/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
                    curl -Lo yazi.zip "https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-gnu.zip"
                    unzip yazi.zip
                    sudo install yazi-x86_64-unknown-linux-gnu/yazi /usr/local/bin/
                    sudo install yazi-x86_64-unknown-linux-gnu/ya /usr/local/bin/
                    rm -rf yazi.zip yazi-x86_64-unknown-linux-gnu
                fi
                
                # git-delta (syntax-highlighting pager for git and diff output)
                if ! command -v delta >/dev/null 2>&1; then
                    DELTA_VERSION=$(curl -s "https://api.github.com/repos/dandavison/delta/releases/latest" | grep -Po '"tag_name": "\K[^"]*')
                    curl -Lo git-delta.deb "https://github.com/dandavison/delta/releases/latest/download/git-delta_${DELTA_VERSION}_amd64.deb"
                    sudo dpkg -i git-delta.deb
                    rm git-delta.deb
                fi
                
                # tlrc (official tldr client written in Rust)
                if ! command -v tldr >/dev/null 2>&1; then
                    TLRC_VERSION=$(curl -s "https://api.github.com/repos/tldr-pages/tlrc/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
                    curl -Lo tlrc.tar.gz "https://github.com/tldr-pages/tlrc/releases/latest/download/tlrc-v${TLRC_VERSION}-x86_64-unknown-linux-gnu.tar.gz"
                    tar xf tlrc.tar.gz
                    sudo install tlrc /usr/local/bin/tldr
                    rm tlrc.tar.gz tlrc
                fi
                
                # wezterm (GPU-accelerated terminal emulator)
                if ! command -v wezterm >/dev/null 2>&1; then
                    curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
                    echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
                    sudo apt update
                    sudo apt install -y wezterm
                fi
                
                # btop (resource monitor)
                if ! command -v btop >/dev/null 2>&1; then
                    BTOP_VERSION=$(curl -s "https://api.github.com/repos/aristocratos/btop/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
                    curl -Lo btop.tbz "https://github.com/aristocratos/btop/releases/latest/download/btop-x86_64-linux-musl.tbz"
                    tar -xjf btop.tbz
                    sudo install btop/bin/btop /usr/local/bin/
                    rm -rf btop.tbz btop
                fi
                
                # ffmpegthumbnailer (create thumbnails for video files)
                if ! command -v ffmpegthumbnailer >/dev/null 2>&1; then
                    sudo apt install -y ffmpegthumbnailer
                fi
                
                # ipcalc (calculate network masks)
                if ! command -v ipcalc >/dev/null 2>&1; then
                    sudo apt install -y ipcalc
                fi
                
                # poppler-utils (PDF utilities)
                if ! command -v pdfinfo >/dev/null 2>&1; then
                    sudo apt install -y poppler-utils
                fi
                
                # yq (YAML/JSON/XML processor)
                if ! command -v yq >/dev/null 2>&1; then
                    YQ_VERSION=$(curl -s "https://api.github.com/repos/mikefarah/yq/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
                    curl -Lo yq "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64"
                    chmod +x yq
                    sudo install yq /usr/local/bin/yq
                    rm yq
                fi
                
                # k9s (Kubernetes CLI)
                if ! command -v k9s >/dev/null 2>&1; then
                    K9S_VERSION=$(curl -s "https://api.github.com/repos/derailed/k9s/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
                    curl -Lo k9s.tar.gz "https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz"
                    tar xf k9s.tar.gz k9s
                    sudo install k9s /usr/local/bin/k9s
                    rm k9s.tar.gz k9s
                fi
                
                # kubie (kubectx/kubens alternative)
                if ! command -v kubie >/dev/null 2>&1; then
                    KUBIE_VERSION=$(curl -s "https://api.github.com/repos/sbstp/kubie/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
                    curl -Lo kubie "https://github.com/sbstp/kubie/releases/latest/download/kubie-linux-amd64"
                    chmod +x kubie
                    sudo install kubie /usr/local/bin/kubie
                    rm kubie
                fi
                
                # lazydocker (docker management)
                if ! command -v lazydocker >/dev/null 2>&1; then
                    LAZYDOCKER_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
                    curl -Lo lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/latest/download/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz"
                    tar xf lazydocker.tar.gz lazydocker
                    sudo install lazydocker /usr/local/bin/
                    rm lazydocker.tar.gz lazydocker
                fi
                
                # GitHub Desktop (optional GUI application)
                if ! command -v github-desktop >/dev/null 2>&1; then
                    echo "Installing GitHub Desktop..."
                    wget -qO - https://apt.packages.shiftkey.dev/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/shiftkey-packages.gpg > /dev/null
                    sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/shiftkey-packages.gpg] https://apt.packages.shiftkey.dev/ubuntu/ any main" > /etc/apt/sources.list.d/shiftkey-packages.list'
                    sudo apt update
                    sudo apt install -y github-desktop
                fi
                ;;
            *)
                echo "Package installation for $DISTRO not implemented yet"
                echo "Only Debian/Ubuntu-based systems are supported."
                echo "Please use a Debian/Ubuntu-based distribution or install packages manually."
                echo ""
                echo "Required packages for manual installation:"
                echo "  curl git neovim stow tmux tree fzf bat htop imagemagick jq nmap ripgrep p7zip openssl"
                echo ""
                echo "Additional tools can be installed from their respective GitHub releases:"
                echo "  eza, zoxide, thefuck, gh, lazygit, git-delta, tlrc, yazi, wezterm, btop, yq, k9s, kubie, lazydocker"
                exit 1
                ;;
        esac
        ;;
    *)
        echo "Unsupported operating system: $OS"
        exit 1
        ;;
esac

# Install Zinit (Zsh plugin manager) if not already installed
ZINIT_HOME="${XDG_DATA_HOME}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
	mkdir -p "$(dirname $ZINIT_HOME)"
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Install tpm (Tmux Plugin Manager) for both macOS and Linux
if [ ! -d "${HOME}/.tmux/plugins/tpm" ]; then
    echo "Installing tpm (Tmux Plugin Manager)..."
    mkdir -p "${HOME}/.tmux/plugins"
    git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
fi

echo "Package installation completed!"
echo ""
echo "Installed tools are now available:"
echo ""
echo "  Core tools:"
echo "    • bat"
echo "    • curl"
echo "    • fzf"
echo "    • git"
echo "    • htop"
echo "    • neovim"
echo "    • stow"
echo "    • tmux"
echo "    • tree"
echo ""
echo "  Modern CLI:"
echo "    • eza"
echo "    • fd"
echo "    • ripgrep"
echo "    • thefuck"
echo "    • tldr"
echo "    • yazi"
echo "    • zoxide"
echo ""
echo "  Development:"
echo "    • gh (GitHub CLI)"
echo "    • git-delta"
echo "    • k9s"
echo "    • kubie"
echo "    • lazydocker"
echo "    • lazygit"
echo ""
echo "  System:"
echo "    • btop"
echo "    • imagemagick"
echo "    • ipcalc"
echo "    • jq"
echo "    • nmap"
echo "    • yq"
echo ""
echo "  Fonts:"
echo "    • MesloLG Nerd Font"
echo "    • Symbols Only Nerd Font"
echo ""
echo "  GUI:"
echo "    • WezTerm terminal"
echo "    • GitHub Desktop (optional)"
echo ""
