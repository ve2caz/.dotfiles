# ~/.zsh/env.zsh - Common to .zshenv and .zprofile
# echo "SOURCED ~/.zsh/env.zsh (PID: $$)"

# --- Idempotency Guard ---
# Login shells source both ~/.zshenv and ~/.zprofile; each sources this file. The guard runs this
# script at most once per zsh process so PATH and the rest are not applied twice in the same shell.
if [ -n "$__UNIFIED_ENVIRONMENT_LOADER" ]; then
    return
fi
# Do not export this flag. Each new zsh child starts fresh and must run this file once: exported
# variables (e.g. PATH) inherit, but eval "$(mise …)" defines functions that do not inherit;
# skipping the whole file (if the guard were exported) would leave those undefined. This runs on
# every new zsh, so keep the rest of this file fast (builds and tools that spawn many shells pay
# this cost repeatedly).
__UNIFIED_ENVIRONMENT_LOADER=1

# XDG Base Directory Specification (https://specifications.freedesktop.org/basedir-spec/latest/)
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-${HOME}/.cache}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-${HOME}/.local/state}"

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

# No folder twice in any search path. zsh keeps entries unique only when the array form is
# assigned, so the end of this file assigns each once more after the string assignments.
typeset -U path fpath manpath
typeset -gxTU INFOPATH infopath

# Homebrew: what `brew shellenv` prints, written out so no shell has to start brew (about 40 ms).
# scripts/doctor.sh compares these with `brew shellenv`. PATH is built below.
_BREW_PREFIX=""
if [[ $OSTYPE == darwin* ]]; then
    if [[ -x /opt/homebrew/bin/brew ]]; then
        _BREW_PREFIX=/opt/homebrew _BREW_REPOSITORY=/opt/homebrew
    elif [[ -x /usr/local/Homebrew/bin/brew ]]; then
        _BREW_PREFIX=/usr/local _BREW_REPOSITORY=/usr/local/Homebrew
    fi
fi
if [[ -n $_BREW_PREFIX ]]; then
    export HOMEBREW_PREFIX=$_BREW_PREFIX
    export HOMEBREW_CELLAR=$_BREW_PREFIX/Cellar
    export HOMEBREW_REPOSITORY=$_BREW_REPOSITORY
    fpath[1,0]="$_BREW_PREFIX/share/zsh/site-functions"
    export FPATH
    [ -z "${MANPATH-}" ] || { export MANPATH="${MANPATH%"${MANPATH##*[!:]}"}"; export MANPATH=":${MANPATH#"${MANPATH%%[!:]*}"}"; }
    export INFOPATH="$_BREW_PREFIX/share/info:${INFOPATH:-}"
    unset _BREW_REPOSITORY
fi

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

# Folders a parent put in front of PATH (saved in .zshenv) go back in front of Homebrew and the
# system folders, behind the shims: the leading run before the first shims, Homebrew or system
# folder. Only absolute folders that exist, never ~/.local/bin or ~/bin, and never mise's version
# folders: a child in another project gets its versions from the shims (ADR 0005).
_mise_data=${MISE_DATA_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/mise}
_system_path=()
[[ -r /etc/paths ]] && _system_path=( ${(f)"$(</etc/paths)"} )
for _f in /etc/paths.d/*(N.); do _system_path+=( ${(f)"$(<$_f)"} ); done
_front=()
for _p in $_zsh_inherited_path; do
    [[ $_p == $_mise_data/shims ]] && break
    (( ${_system_path[(Ie)$_p]} )) && break
    [[ -n $_BREW_PREFIX && $_p == $_BREW_PREFIX/(bin|sbin|opt/curl/bin) ]] && break
    [[ $_p == /* && -d $_p ]] || continue
    [[ $_p == $_mise_data/installs/* || $_p == $HOME/.local/bin || $_p == $HOME/bin ]] && continue
    _front+=( $_p )
done
path=( $_front $path )
unset _mise_data _system_path _front _p _f _zsh_inherited_path

# Additional high-priority developer paths (append if present)
# Append as a security measure to avoid shadowing Brew, and system binaries
[[ -d "$HOME/.local/bin" ]] && path=( $path "$HOME/.local/bin" )
[[ -d "$HOME/bin" ]] && path=( $path "$HOME/bin" )

# --- Finalize and Export ---
export PATH

# --- No PATH modifications beyond this point, except the mise shims below ---

# A kubeconfig with no top-level clusters: key, such as a failed Rancher download that kubie picked
# up, breaks kubectl and the prompt in every shell: fall back to ~/.kube/config, or drop the variable.
# zsh reads the file itself, so the check starts no program.
_kubeconfig_ok() { [[ -f $1 && $'\n'$(<$1) =~ $'\n''[[:space:]]*clusters:' ]] }
if [[ -n ${KUBIE_KUBECONFIG-} ]] && ! _kubeconfig_ok "$KUBIE_KUBECONFIG"; then
    if _kubeconfig_ok "$HOME/.kube/config"; then
        export KUBIE_KUBECONFIG="$HOME/.kube/config"
    else
        unset KUBIE_KUBECONFIG
    fi
fi
if [[ -n ${KUBECONFIG-} ]] && ! _kubeconfig_ok "${KUBECONFIG%%:*}"; then
    if [[ -n ${KUBIE_KUBECONFIG-} ]]; then
        export KUBECONFIG="$KUBIE_KUBECONFIG"
    else
        unset KUBECONFIG
    fi
fi
unfunction _kubeconfig_ok

# Plugins that require explicit environment variable setup
# These use zsh precmd hooks to dynamically update env vars based on the active version

# --- Runtime Version Manager (mise) ---
# Initialize shims for all shell types (login, non-login, interactive, non-interactive)
# This ensures version-managed tools are available everywhere
if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate zsh --shims)"
fi

path=( $path )
fpath=( $fpath )
manpath=( "${manpath[@]}" )
infopath=( "${infopath[@]}" )
