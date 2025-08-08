#!/bin/bash
# Setup asdf plugins
# This script installs asdf plugins if they have not yet been installed

set -e

echo "🔌 Setting up asdf plugins..."

# Ensure asdf is available
if ! command -v asdf >/dev/null 2>&1; then
    # Try to load asdf if it's installed but not in PATH
    if [ -f "$HOME/.asdf/asdf.sh" ]; then
        . "$HOME/.asdf/asdf.sh"
    elif [ -f "${ASDF_DATA_DIR:-$HOME/.asdf}/asdf.sh" ]; then
        . "${ASDF_DATA_DIR:-$HOME/.asdf}/asdf.sh"
    else
        echo "❌ asdf is not installed. Please install asdf first."
        exit 1
    fi
fi

# Function to add plugin if not already added
add_plugin_if_missing() {
    local plugin=$1
    
    # Check if plugin is already installed
    if ! asdf plugin list | grep -q "^${plugin}$"; then
        echo "➕ Adding asdf plugin: ${plugin}"
        asdf plugin add "${plugin}"
    else
        echo "✓ asdf plugin already installed: ${plugin}"
    fi
}

# Add required plugins
add_plugin_if_missing "golang"
add_plugin_if_missing "gradle"
add_plugin_if_missing "java"
add_plugin_if_missing "kind"
add_plugin_if_missing "kotlin"
add_plugin_if_missing "krew"
add_plugin_if_missing "kubectl"
add_plugin_if_missing "maven"
add_plugin_if_missing "nodejs"
add_plugin_if_missing "python"
add_plugin_if_missing "rust"

echo "✅ asdf plugins setup complete"
