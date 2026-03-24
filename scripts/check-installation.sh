#!/bin/bash
# Check which tools from the dotfiles are installed and available
# Only macOS and Debian/Ubuntu Linux are supported by the install script.
#
# Note: Using bash instead of zsh for maximum compatibility during initial setup.
# This script runs before zsh configuration is deployed, so bash ensures it works
# on fresh systems where zsh might not be the default shell yet. Bash is guaranteed
# to be available on macOS and virtually all Linux distributions out of the box.

# XDG Base Directory Specification (externalized)
_XDG_BASE_DIRS_FILE="$HOME/.zsh/.zsh-xdg-base-dirs"
if [ -f "$_XDG_BASE_DIRS_FILE" ]; then
    source "$_XDG_BASE_DIRS_FILE"
fi

# Ensure XDG defaults are available (fallback for first-run or direct script execution)
: "${XDG_CACHE_HOME:=${HOME}/.cache}"
: "${XDG_CONFIG_HOME:=${HOME}/.config}"
: "${XDG_DATA_HOME:=${HOME}/.local/share}"
: "${XDG_STATE_HOME:=${HOME}/.local/state}"
export XDG_CONFIG_HOME XDG_DATA_HOME XDG_CACHE_HOME XDG_STATE_HOME

echo "=== Dotfiles Tool Installation Check ==="
echo ""

check_tool() {
    local tool="$1"
    local description="$2"
    local os_name="$(uname -s)"
    local found_path=""
    # Check with command -v first
    if command -v "$tool" >/dev/null 2>&1; then
        found_path="$(command -v "$tool")"
        echo "✅ $tool (found at $found_path) - $description"
        return 0
    fi
    # Check common Homebrew and Linux install locations
    local search_paths=(
        "/opt/homebrew/bin/$tool"
        "/usr/local/bin/$tool"
        "/usr/bin/$tool"
        "$HOME/.local/bin/$tool"
    )
    for p in "${search_paths[@]}"; do
        if [ -x "$p" ]; then
            echo "✅ $tool (found at $p) - $description"
            return 0
        fi
    done
    echo "❌ $tool - $description"
    return 1
}

check_category() {
    local category_name="$1"
    shift
    local tools=("$@")
    local found=0
    local total=$((${#tools[@]} / 2))
    
    echo "--- $category_name ---"
    for ((i=0; i<${#tools[@]}; i+=2)); do
        if check_tool "${tools[i]}" "${tools[i+1]}"; then
            ((found++))
        fi
    done
    echo "   ($found/$total installed)"
    echo ""
}

# Define tool lists (tool, description pairs)
CORE_TOOLS=(
    "bat" "Syntax highlighting cat"
    "curl" "HTTP client"
    "direnv" "Environment variable manager"
    "fzf" "Fuzzy finder"
    "git" "Version control" 
    "htop" "Process monitor"
    "jq" "JSON processor"
    "nmap" "Network scanner"
    "nvim" "Text editor (neovim)"
    "rg" "Fast text search (ripgrep)"
    "stow" "Symlink manager"
    "tmux" "Terminal multiplexer"
    "tree" "Directory tree view"
)

MODERN_CLI=(
    "dust" "Intuitive disk usage (du)"
    "eza" "Modern ls replacement"
    "fd" "Fast find alternative" 
    "thefuck" "Command corrector"
    "tldr" "Simplified man pages"
    "yazi" "Terminal file manager"
    "zoxide" "Smart cd command"
)

DEVELOPMENT=(
    "delta" "Git diff pager"
    "gh" "GitHub CLI"
    "k9s" "Kubernetes CLI"
    "kubie" "Kubernetes context"
    "mise" "Polyglot version manager"
    "regctl" "regclient/regctl is Docker/OCI registry client"
    "lazydocker" "Docker terminal UI"
    "lazygit" "Git terminal UI"
)

SYSTEM_TOOLS=(
    "btop" "System monitor"
    "ipcalc" "IP calculator"
    "wezterm" "Terminal emulator"
    "yq" "YAML/JSON processor"
)

# Check all categories
check_category "Core Tools" "${CORE_TOOLS[@]}"
check_category "Modern CLI Tools" "${MODERN_CLI[@]}"
check_category "Development Tools" "${DEVELOPMENT[@]}"
check_category "System Tools" "${SYSTEM_TOOLS[@]}"

# Check fonts
echo "--- Fonts ---"
if fc-list 2>/dev/null | grep -i "meslo.*nerd" >/dev/null 2>&1; then
    echo "✅ MesloLG Nerd Font"
else
    echo "❌ MesloLG Nerd Font (or fc-list not available)"
fi

if fc-list 2>/dev/null | grep -i "symbols.*nerd" >/dev/null 2>&1; then
    echo "✅ Symbols Only Nerd Font"  
else
    echo "❌ Symbols Only Nerd Font (or fc-list not available)"
fi
echo ""

# Summary
echo "=== Summary ==="
echo "Run './scripts/install-packages.sh' to install missing tools"
echo "Run 'stow .' to activate dotfiles configuration"  
echo "Run 'exec zsh' to reload shell environment"
