# ~/.zsh/env.zsh - Common to .zshenv and .zprofile
# echo "SOURCED ~/.zsh/env.zsh (PID: $$)"

# --- Idempotency Guard ---
# If this variable is already set, we've already run. Do nothing.
if [ -n "$__UNIFIED_ENVIRONMENT_LOADER" ]; then
    return
fi
export __UNIFIED_ENVIRONMENT_LOADER=1

# XDG Base Directory Specification (externalized)
_XDG_BASE_DIRS_FILE="$HOME/.zsh/.zsh-xdg-base-dirs"
if [ -f "$_XDG_BASE_DIRS_FILE" ]; then
    source "$_XDG_BASE_DIRS_FILE"
fi

# Locale Configuration: enforce UTF-8 while keeping region-specific settings
_LOCALE_FILE="$HOME/.zsh/locale.zsh"
if [ -f "$_LOCALE_FILE" ]; then
    source "$_LOCALE_FILE"
    if [[ -o interactive ]]; then
        : # Skip; .zshrc will call ensure_utf8_locale after user config
    else
        # For non-interactive shells, ensure UTF-8
        ensure_utf8_locale
    fi
fi

# Detect the brew prefix based on OS and architecture
# `brew shellenv` runs path_helper on macOS automatically
_BREW_PREFIX=""
case "$(uname -s)" in
    # Set up Homebrew
    Darwin)
        # Apple Silicon (M1/M2/M3)
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
            _BREW_PREFIX="/opt/homebrew"
        # Intel Macs
        elif [[ -f "/usr/local/Homebrew/bin/brew" ]]; then
            eval "$(/usr/local/Homebrew/bin/brew shellenv)"
            _BREW_PREFIX="/usr/local"
        fi
        ;;
    Linux)
        # Homebrew on Linux (linuxbrew)
        if [[ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
            _BREW_PREFIX="/home/linuxbrew/.linuxbrew"
        elif [[ -x "$HOME/.linuxbrew/bin/brew" ]]; then
            eval "$("$HOME/.linuxbrew/bin/brew" shellenv)"
            _BREW_PREFIX="$HOME/.linuxbrew"
        fi
        ;;
esac

# --- Unified PATH Management (zsh array) ---
# Use a unique array for PATH to preserve order and avoid duplicates.
typeset -U path

if [[ -n "$_BREW_PREFIX" ]]; then
    # Ensure brew bin/sbin are prioritized
    [[ -d "$_BREW_PREFIX/bin" ]] && path=( "$_BREW_PREFIX/bin" $path )
    [[ -d "$_BREW_PREFIX/sbin" ]] && path=( "$_BREW_PREFIX/sbin" $path )

    # Prefer Homebrew curl if available
    [[ -d "$_BREW_PREFIX/opt/curl/bin" ]] && path=( "$_BREW_PREFIX/opt/curl/bin" $path )
fi

# Additional high-priority developer paths (append if present)
# Append as a security measure to avoid shadowing Brew, and system binaries
[[ -d "$HOME/.local/bin" ]] && path=( $path "$HOME/.local/bin" )
[[ -d "$HOME/bin" ]] && path=( $path "$HOME/bin" )

# --- Finalize and Export ---
export PATH

# --- No PATH modifications beyond this point ---

# Plugins that require explicit environment variable setup
# These use zsh precmd hooks to dynamically update env vars based on the active version

# Enable direnv integration with zsh (cross-platform)
if command -v direnv >/dev/null 2>&1; then
    eval "$(direnv hook zsh)"
fi
