#!/bin/bash
# Check which tools from the dotfiles are installed and available

echo "=== Dotfiles Tool Installation Check ==="
echo ""

check_tool() {
    local tool="$1"
    local description="$2"
    if command -v "$tool" >/dev/null 2>&1; then
        echo "✅ $tool - $description"
        return 0
    else
        echo "❌ $tool - $description"
        return 1
    fi
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
    "curl" "HTTP client"
    "git" "Version control" 
    "nvim" "Text editor (neovim)"
    "stow" "Symlink manager"
    "tmux" "Terminal multiplexer"
    "tree" "Directory tree view"
    "fzf" "Fuzzy finder"
    "bat" "Syntax highlighting cat"
    "htop" "Process monitor"
    "jq" "JSON processor"
    "nmap" "Network scanner"
    "rg" "Fast text search (ripgrep)"
)

MODERN_CLI=(
    "eza" "Modern ls replacement"
    "fd" "Fast find alternative" 
    "zoxide" "Smart cd command"
    "yazi" "Terminal file manager"
    "thefuck" "Command corrector"
    "tldr" "Simplified man pages"
)

DEVELOPMENT=(
    "gh" "GitHub CLI"
    "lazygit" "Git terminal UI"
    "delta" "Git diff pager"
    "k9s" "Kubernetes CLI"
    "kubie" "Kubernetes context"
    "lazydocker" "Docker terminal UI"
)

SYSTEM_TOOLS=(
    "btop" "System monitor"
    "yq" "YAML/JSON processor"
    "ipcalc" "IP calculator"
    "wezterm" "Terminal emulator"
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

# Check tmux plugin manager
echo "--- Tmux Plugins ---"
if [ -d "${XDG_DATA_HOME:-${HOME}/.local/share}/tmux/plugins/tpm" ]; then
    echo "✅ TPM (Tmux Plugin Manager)"
else
    echo "❌ TPM (Tmux Plugin Manager)"
fi
echo ""

# Summary
echo "=== Summary ==="
echo "Run './scripts/install-packages.sh' to install missing tools"
echo "Run 'stow .' to activate dotfiles configuration"  
echo "Run 'exec zsh' to reload shell environment"
