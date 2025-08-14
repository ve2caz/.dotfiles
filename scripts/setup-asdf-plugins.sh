#!/bin/bash
# This script installs asdf plugins if they have not yet been installed
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

echo "🔌 Setting up asdf plugins..."

# --- Generalized asdf detection and PATH setup ---
ASDF_BIN=""
# Check common Homebrew and manual install locations
if [ -x "/opt/homebrew/bin/asdf" ]; then
    ASDF_BIN="/opt/homebrew/bin/asdf"
elif [ -x "/usr/local/bin/asdf" ]; then
    ASDF_BIN="/usr/local/bin/asdf"
elif [ -x "${XDG_DATA_HOME}/asdf/bin/asdf" ]; then
    ASDF_BIN="${XDG_DATA_HOME}/asdf/bin/asdf"
elif [ -x "$HOME/.asdf/bin/asdf" ]; then
    ASDF_BIN="$HOME/.asdf/bin/asdf"
fi

if [ -n "$ASDF_BIN" ]; then
    PATH="$(dirname "$ASDF_BIN"):$PATH"
else
    echo "❌ asdf is not installed or not available in a known location. Please install asdf using brew (macOS) or clone to ~/.asdf or ${XDG_DATA_HOME:-$HOME/.local/share}/asdf (Linux)."
    exit 1
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

# Define the list of expected plugins
ASDF_PLUGINS=(
    "ctlptl"
    "golang"
    "gradle"
    "helm"
    "java"
    "kind"
    "kotlin"
    "krew"
    "kubebuilder"
    "kubectl"
    "maven"
    "mockery"
    "nodejs"
    "python"
    "rancher"
    "rust"
    "step"
    "tilt"
)

# Loop over the list of plugins and add each if missing
for plugin in "${ASDF_PLUGINS[@]}"; do
    add_plugin_if_missing "$plugin"
done

echo "✅ asdf plugins setup complete"
