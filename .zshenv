# .zshenv - Login, Interactive, and Non-Interactive Shells

# Guard to prevent double sourcing
export ZSHENV_SOURCED=1
# echo "SOURCED .zshenv"

# XDG Base Directory Specification
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-${HOME}/.cache}"

# Locale Configuration
# Ensure consistent locale settings
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Detect operating system
case "$(uname -s)" in
    Darwin)
        # MacOS - Set up Homebrew
        # Apple Silicon (M1/M2/M3)
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
            # Add Homebrew curl to PATH (newer version instead of Apple's curl)
            export PATH="/opt/homebrew/opt/curl/bin:$PATH"
        # Intel Macs
        elif [[ -f "/usr/local/Homebrew/bin/brew" ]]; then
            eval "$(/usr/local/Homebrew/bin/brew shellenv)"
            # Add Homebrew curl to PATH (newer version instead of Apple's curl)
            export PATH="/usr/local/opt/curl/bin:$PATH"
        fi
        ;;
    Linux)
        # Linux - Add common binary paths if they exist
        for path in "/usr/local/bin" "/opt/bin" "$HOME/.local/bin" "$HOME/bin"; do
            [[ -d "$path" ]] && export PATH="$path:$PATH"
        done
        ;;
esac

# ASDF version manager - Add shims to PATH (cross-platform)
# Only add to PATH if ASDF directory exists
if [[ -d "${ASDF_DATA_DIR:-$HOME/.asdf}" ]]; then
    export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
fi

# Enable direnv integration with zsh
if command -v direnv >/dev/null 2>&1; then
    eval "$(direnv hook zsh)"
fi
