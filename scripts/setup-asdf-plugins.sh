#!/bin/bash
# This script installs asdf plugins if they have not yet been installed
#
# Note: Using bash instead of zsh for maximum compatibility during initial setup.
# This script runs before zsh configuration is deployed, so bash ensures it works
# on fresh systems where zsh might not be the default shell yet. Bash is guaranteed
# to be available on MacOS and virtually all Linux distributions out of the box.

# Ensure script exits on error
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
