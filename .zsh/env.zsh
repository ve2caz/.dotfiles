# ~/.zsh/env.zsh - Common to .zshenv and .zprofile
# echo "SOURCED ~/.zsh/env.zsh (PID: $$)"

# --- Idempotency Guard ---
# Login shells source both ~/.zshenv and ~/.zprofile; each sources this file. The guard runs this
# script at most once per zsh process so PATH and the rest are not applied twice in the same shell.
if [ -n "$__UNIFIED_ENVIRONMENT_LOADER" ]; then
    return
fi
# Do not export this flag. Each new zsh child starts fresh and must run this file once: exported
# variables (e.g. PATH) inherit, but eval "$(mise …)" / eval "$(direnv hook zsh)" define functions
# and hooks that do not inherit—skipping the whole file (if the guard were exported) would leave
# those undefined. This runs on every new zsh, so keep the rest of this file fast (builds and tools
# that spawn many shells pay this cost repeatedly).
__UNIFIED_ENVIRONMENT_LOADER=1

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

# --- Runtime Version Manager (mise) ---
# Initialize shims for all shell types (login, non-login, interactive, non-interactive)
# This ensures version-managed tools are available everywhere
if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate zsh --shims)"
fi

# Enable direnv integration with zsh (cross-platform)
if command -v direnv >/dev/null 2>&1; then
    eval "$(direnv hook zsh)"
fi
