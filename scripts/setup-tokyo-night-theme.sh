#!/bin/bash
# Tokyo Night Theme Setup Script
# Ensures all tools use consistent Tokyo Night theming

set -e

echo "🎨 Setting up Tokyo Night theme across all tools..."

# Use XDG Base Directory Specification
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-${HOME}/.cache}"

# Export XDG variables for consistency
export XDG_CONFIG_HOME XDG_DATA_HOME XDG_CACHE_HOME

# Create config and data directories if they don't exist
mkdir -p "${XDG_CONFIG_HOME}/bat/themes"
mkdir -p "${XDG_CONFIG_HOME}/yazi/flavors"

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

# Install Tokyo Night theme for yazi (if available)
echo "📁 Setting up yazi theme..."
YAZI_FLAVORS_DIR="${XDG_CONFIG_HOME}/yazi/flavors"
TOKYO_NIGHT_FLAVOR="$YAZI_FLAVORS_DIR/tokyo-night/flavor.toml"
if [ -f "$TOKYO_NIGHT_FLAVOR" ]; then
    echo "✅ yazi Tokyo Night flavor already available"
else
    echo "⚠️  yazi Tokyo Night flavor not found at $TOKYO_NIGHT_FLAVOR"
    echo "    Make sure to stow the dotfiles to install the custom Tokyo Night flavor"
fi

# Verify btop Tokyo Night theme
echo "📊 Verifying btop theme..."
BTOP_THEMES_DIR="${XDG_CONFIG_HOME}/btop/themes"
if [ ! -d "$BTOP_THEMES_DIR" ] || [ ! -f "$BTOP_THEMES_DIR/tokyo-night.theme" ]; then
    echo "⚠️  btop Tokyo Night theme may need manual installation"
    echo "    Check https://github.com/rxyhn/tokyo-night-btop for theme file"
else
    echo "✅ btop theme verified"
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
echo "3. Reload tmux: tmux source-file ~/.tmux.conf"
echo "4. Restart shell to apply Powerlevel10k changes: exec zsh"
echo ""
echo "All tools should now use consistent Tokyo Night theming! 🌃"
