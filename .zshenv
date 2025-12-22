# .zshenv - ALL shells (Login, Non-login, Interactive, Non-interactive)

# XDG Base Directory Specification (externalized)
_XDG_BASE_DIRS_FILE="$HOME/.zsh-xdg-base-dirs"
if [ -f "$_XDG_BASE_DIRS_FILE" ]; then
    source "$_XDG_BASE_DIRS_FILE"
fi

# Prevent double sourcing
if [ -z "$__ZSHENV_SOURCED" ]; then
    export __ZSHENV_SOURCED=1
    # echo "SOURCED .zshenv (PID: $$)"

    # Locale Configuration
    # Ensure consistent locale settings
    export LANG="en_US.UTF-8"
    export LC_ALL="en_US.UTF-8"

    # Detect operating system
    case "$(uname -s)" in
        # Set up Homebrew
        Darwin)
            # Apple Silicon (M1/M2/M3)
            if [[ -f "/opt/homebrew/bin/brew" ]]; then
                eval "$('/opt/homebrew/bin/brew' shellenv)"
                export PATH="/opt/homebrew/opt/curl/bin:$PATH"
            # Intel Macs
            elif [[ -f "/usr/local/Homebrew/bin/brew" ]]; then
                eval "$('/usr/local/Homebrew/bin/brew' shellenv)"
                export PATH="/usr/local/opt/curl/bin:$PATH"
            fi
            ;;
        Linux)
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

    # Plugins that require explicit environment variable setup
    # These use zsh precmd hooks to dynamically update env vars based on the active version
    
    # Source Go set-env script if it exists
    _ASDF_GO_SCRIPT="$_ASDF_DIR/plugins/golang/set-env.zsh"
    if [[ -f "$_ASDF_GO_SCRIPT" ]]; then
        source "$_ASDF_GO_SCRIPT"
        
        # Override the buggy asdf_update_golang_env function with a safer version
        asdf_update_golang_env() {
            # Only proceed if go command is actually available
            if ! command -v go >/dev/null 2>&1; then
                return 0
            fi
            
            local go_root
            go_root="$(go env GOROOT 2>/dev/null)"
            
            # Only set environment variables if GOROOT is valid and points to an existing directory
            if [[ -n "${go_root}" && -d "${go_root}" ]]; then
                export GOROOT="${go_root}"
                # Use standard Go workspace location for GOPATH (Go 1.8+ supports this)
                export GOPATH="${HOME}/go"
                export GOBIN="${GOPATH}/bin"
            fi
        }
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

fi
