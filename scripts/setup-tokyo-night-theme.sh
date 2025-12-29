#!/bin/bash
# Tokyo Night Theme Setup Script
# Ensures all tools use consistent Tokyo Night theming
#
# Note: Using bash instead of zsh for maximum compatibility during initial setup.
# This script runs before zsh configuration is deployed, so bash ensures it works
# on fresh systems where zsh might not be the default shell yet. Bash is guaranteed
# to be available on macOS and virtually all Linux distributions out of the box.

# Ensure script exits on error
set -e

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

echo "🎨 Setting up Tokyo Night theme across all tools..."

# Create config and data directories if they don't exist
mkdir -p "${XDG_CONFIG_HOME}/bat/themes"

# Download and install Tokyo Night theme for bat
echo "📄 Setting up bat theme..."
BAT_THEMES_DIR="${XDG_CONFIG_HOME}/bat/themes"
if [ ! -f "$BAT_THEMES_DIR/tokyonight_night.tmTheme" ]; then
    curl -L -o "$BAT_THEMES_DIR/tokyonight_night.tmTheme" \
        "https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/sublime/tokyonight_night.tmTheme"
    bat cache --build
    echo "✅ bat theme installed"
else
    echo "✅ bat theme already installed"
fi

# Verify yazi Tokyo Night theme is available via dotfiles
echo "📁 Verifying yazi theme..."
TOKYO_NIGHT_FLAVOR="${XDG_CONFIG_HOME}/yazi/flavors/tokyo-night.yazi/flavor.toml"
if [ -f "$TOKYO_NIGHT_FLAVOR" ]; then
    echo "✅ yazi Tokyo Night flavor available"
else
    echo "⚠️  yazi Tokyo Night flavor not found at $TOKYO_NIGHT_FLAVOR"
    echo "    Make sure dotfiles are properly stowed/linked"
fi

echo ""
echo "🎉 Tokyo Night theme setup complete!"
echo ""
echo "📁 All configurations follow XDG Base Directory Specification:"
echo "   Config: ${XDG_CONFIG_HOME}"
echo "   Data:   ${XDG_DATA_HOME}"
echo "   Cache:  ${XDG_CACHE_HOME}"
echo ""
echo "Next steps:"
echo "1. If packages aren't installed, run: ./scripts/install-packages.sh"
echo "2. Restart your terminal to apply WezTerm changes"
echo "3. Reload tmux: tmux source-file \${XDG_CONFIG_HOME}/tmux/tmux.conf"
echo ""
echo "All tools should now use consistent Tokyo Night theming! 🌃"
