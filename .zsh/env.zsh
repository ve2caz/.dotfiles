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

# ASDF version manager - Add shims to PATH (cross-platform)
# Default to ~/.asdf if ASDF_DATA_DIR is not set
_ASDF_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}"
if [[ -d "$_ASDF_DIR" ]]; then
    path=( "$_ASDF_DIR/shims" $path )
fi

# Additional high-priority developer paths (append if present)
# Append as a security measure to avoid shadowing ASDF, Brew, and system binaries
[[ -d "$HOME/.local/bin" ]] && path=( $path "$HOME/.local/bin" )
[[ -d "$HOME/bin" ]] && path=( $path "$HOME/bin" )

# --- Finalize and Export ---
export PATH

# --- No PATH modifications beyond this point ---

# Plugins that require explicit environment variable setup
# These use zsh precmd hooks to dynamically update env vars based on the active version

# Source Go set-env script if it exists
_ASDF_GO_SCRIPT="$_ASDF_DIR/plugins/golang/set-env.zsh"
if [[ -f "$_ASDF_GO_SCRIPT" ]]; then
    source "$_ASDF_GO_SCRIPT"
    
    # # Override the asdf_update_golang_env function with a safer version
    # asdf_update_golang_env() {
    #     # Only proceed if go command is actually available
    #     if ! command -v go >/dev/null 2>&1; then
    #         return 0
    #     fi
        
    #     local go_root
    #     go_root="$(go env GOROOT 2>/dev/null)"
        
    #     # Only set environment variables if GOROOT is valid and points to an existing directory
    #     if [[ -n "${go_root}" && -d "${go_root}" ]]; then
    #         export GOROOT="${go_root}"
    #         # Use standard Go workspace location for GOPATH (Go 1.8+ supports this)
    #         export GOPATH="${HOME}/go"
    #         export GOBIN="${GOPATH}/bin"
    #     fi
    # }
fi

# Source Java set-java-home script if it exists
_ASDF_JAVA_SCRIPT="$_ASDF_DIR/plugins/java/set-java-home.zsh"
if [[ -f "$_ASDF_JAVA_SCRIPT" ]]; then
    source "$_ASDF_JAVA_SCRIPT"
fi

# Enable direnv integration with zsh (cross-platform)
if command -v direnv >/dev/null 2>&1; then
    eval "$(direnv hook zsh)"
fi
