# .zprofile - Zsh profile configuration

# Locale Configuration
# Ensure consistent locale settings for all applications including VS Code
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"

# Detect operating system
case "$(uname -s)" in
    Darwin)
        # MacOS - Set up Homebrew
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
            # Add Homebrew curl to PATH (newer version instead of Apple's curl)
            export PATH="/opt/homebrew/opt/curl/bin:$PATH"
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
