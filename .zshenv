# .zshenv - Login, Interactive, and Non-Interactive Shells

# XDG Base Directory Specification (externalized)
_XDG_BASE_DIRS_FILE="$HOME/.zsh-xdg-base-dirs"
if [ -f "$_XDG_BASE_DIRS_FILE" ]; then
    source "$_XDG_BASE_DIRS_FILE"
fi

# Prevent double sourcing
if [ -z "$__ZSHENV_SOURCED" ]; then
    export __ZSHENV_SOURCED=1
    # echo "SOURCED .zshenv"

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
    # Default to ~/.asdf if ASDF_DATA_DIR is not set
    _ASDF_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}"
    if [[ -d "$_ASDF_DIR" ]]; then
        export PATH="$_ASDF_DIR/shims:$PATH"
    fi

    # Enable direnv integration with zsh (cross-platform)
    if command -v direnv >/dev/null 2>&1; then
        eval "$(direnv hook zsh)"
    fi

fi
