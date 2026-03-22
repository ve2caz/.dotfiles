#!/bin/bash
# Orchestrates complete .dotfiles installation
#
# Note: Using bash instead of zsh for maximum compatibility during initial setup.
# This script runs before zsh configuration is deployed, so bash ensures it works
# on fresh systems where zsh might not be the default shell yet. Bash is guaranteed
# to be available on macOS and virtually all Linux distributions out of the box.

# Ensure script exits on error
set -e

echo "🎛️  .dotfiles Master Setup"
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
    echo "   Install with: brew install stow (macOS) or sudo apt install stow (Linux)"
    exit 1
fi

# Step 3: Stow dotfiles
echo "📂 Step 2: Installing dotfiles with stow..."
echo "  1. Running 'stow . --target="$HOME"' from the .dotfiles directory to activate configuration"
echo "  2. Restart your shell or run 'exec zsh' to load the new environment once setup completes"
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
echo "• Zsh with Starship (Tokyo Night colors)"
echo "• Tmux with plugins (blue theme)"
echo "• Bat (Tokyo Night syntax highlighting)"
echo "• Yazi (Tokyo Night file manager)"
echo "• btop (Tokyo Night system monitor)"
echo ""
echo "Enjoy your new development environment! ✨"
