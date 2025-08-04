# .zprofile - Zsh profile configuration

# Detect operating system
case "$(uname -s)" in
    Darwin)
        # macOS - Set up Homebrew
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
