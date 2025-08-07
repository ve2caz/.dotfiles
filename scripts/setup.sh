#!/bin/bash
# Master Dotfiles Setup Script
# Orchestrates complete dotfiles installation

set -e

echo "🎛️  Dotfiles Master Setup"
echo "======================="
echo ""

# Step 1: Install packages first (if not already done)
echo "📦 Step 1: Installing packages..."
if [ -f "./scripts/install-packages.sh" ]; then
    echo "🔧 Running package installation (this may take a while)..."
    ./scripts/install-packages.sh
else
    echo "⚠️  install-packages.sh not found, skipping package installation"
    echo "   Make sure required tools are installed manually"
fi
echo ""

# Step 2: Check if stow is available (should be installed by step 1)
if ! command -v stow >/dev/null 2>&1; then
    echo "❌ GNU Stow is required but not installed."
    echo "   Install with: brew install stow (MacOS) or sudo apt install stow (Linux)"
    exit 1
fi

# Step 3: Stow dotfiles
echo "📂 Step 2: Installing dotfiles with stow..."
stow . --target="$HOME"
echo "✅ Dotfiles stowed successfully"
echo ""

# Step 4: Setup Tokyo Night theme
echo "🎨 Step 3: Setting up Tokyo Night theme..."
./scripts/setup-tokyo-night-theme.sh
echo ""

# Step 5: Final instructions
echo "🎉 Setup Complete!"
echo "================="
echo ""
echo "Your dotfiles are now installed with:"
echo "• All required packages installed via install-packages.sh"
echo "• XDG Base Directory Specification compliance"
echo "• Consistent Tokyo Night theming across all tools"
echo "• All dependencies properly configured"
echo ""
echo "To apply all changes:"
echo "1. Restart your terminal"
echo "2. Run: exec zsh"
echo ""
echo "Tools configured:"
echo "• WezTerm (terminal with Tokyo Night colors)"
echo "• Zsh with Powerlevel10k (Tokyo Night colors)"
echo "• Tmux with plugins (blue theme)"
echo "• Bat (Tokyo Night syntax highlighting)"
echo "• Yazi (Tokyo Night file manager)"
echo "• btop (Tokyo Night system monitor)"
echo ""
echo "Enjoy your new development environment! ✨"
