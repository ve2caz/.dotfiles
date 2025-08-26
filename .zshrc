
# ============================================================================
#  .zshrc - Login and Interactive Shells
# ============================================================================

# --- Zsh Key Timeout ---
# The time (in hundredths of a second) that Zsh waits for a key sequence to complete.
# Increase if you use slow key chords or custom keybindings. Default is 40 (0.4s).
KEYTIMEOUT=50

# --- Environment Variables ---
STARSHIP_CONFIG="${XDG_CONFIG_HOME}/starship/starship.toml"       # Starship prompt configuration
LESS='-R'                                                         # Display colors correctly
PAGER='less -R'                                                   # Set less as default pager with color support
FZFGIT_HOME="${XDG_DATA_HOME}/fzf-git"                            # FZF Git integration

# --- VS Code Shell Integration ---
if [[ "$TERM_PROGRAM" == "vscode" ]]; then
    if command -v code >/dev/null 2>&1; then
        vscode_shell_integration="$(code --locate-shell-integration-path zsh 2>/dev/null)"
        if [[ -r "$vscode_shell_integration" ]]; then
            source "$vscode_shell_integration"
        fi
    fi
fi

# --- Plugin Manager ---
if [[ -r "${XDG_DATA_HOME}/zinit/zinit.git/zinit.zsh" ]]; then
    source "${XDG_DATA_HOME}/zinit/zinit.git/zinit.zsh"
else
    echo "[.zshrc] Warning: zinit not found at ${XDG_DATA_HOME}/zinit/zinit.git/zinit.zsh"
fi

# --- Plugins ---
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light Aloxaf/fzf-tab
zinit light sinetoami/web-search

# --- Prompt ---
eval "$(starship init zsh)"

# --- Completions ---
 # asdf version manager - Setup completions before compinit
if command -v asdf >/dev/null 2>&1; then
    ASDF_COMPLETIONS="$HOME/.asdf/completions"
    [[ ! -d "$ASDF_COMPLETIONS" ]] && mkdir -p "$ASDF_COMPLETIONS"
    if [[ ! -f "$ASDF_COMPLETIONS/_asdf" ]] || [[ "$ASDF_COMPLETIONS/_asdf" -ot "$(command -v asdf)" ]]; then
        asdf completion zsh > "$ASDF_COMPLETIONS/_asdf"
    fi
    fpath=("$ASDF_COMPLETIONS" $fpath)
fi
autoload -U compinit && compinit -C

# --- Plugin Post-Init ---
zinit cdreplay -q

# --- History ---
HISTFILE="${XDG_DATA_HOME}/zsh/history"
HISTSIZE=5000
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# --- Pager & Colors ---
if command -v bat >/dev/null 2>&1; then
    BAT_THEME=tokyonight_night
    LESSOPEN='|bat --color=always %s'
fi
if command -v dircolors >/dev/null 2>&1; then
    eval "$(dircolors -b)"
elif command -v gdircolors >/dev/null 2>&1; then
    eval "$(gdircolors -b)"
else
    LS_COLORS='di=1;34:ln=1;36:so=1;35:pi=1;33:ex=1;32:bd=1;33:cd=1;33:su=1;31:sg=1;31:tw=1;34:ow=1;34:*.tar=1;31:*.tgz=1;31:*.zip=1;31:*.gz=1;31:*.bz2=1;31:*.xz=1;31:*.lz=1;31:*.jpg=1;35:*.jpeg=1;35:*.png=1;35:*.gif=1;35:*.svg=1;35:*.pdf=1;31:*.doc=1;31:*.docx=1;31:*.xls=1;31:*.xlsx=1;31:*.ppt=1;31:*.pptx=1;31:*.mp3=1;36:*.mp4=1;36:*.avi=1;36:*.mkv=1;36:*.mov=1;36:*.js=1;33:*.ts=1;33:*.py=1;33:*.rb=1;33:*.go=1;33:*.rs=1;33:*.cpp=1;33:*.c=1;33:*.h=1;33:*.css=1;33:*.html=1;33:*.json=1;33:*.xml=1;33:*.yml=1;33:*.yaml=1;33'
fi
export EZA_COLORS=$LS_COLORS
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# --- Keybindings ---
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# --- Aliases & Functions ---
alias cls='clear'
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --color=auto --group-directories-first'
    alias l='eza -lh --color=auto --group-directories-first'
    alias la='eza -lah --color=auto --group-directories-first'
    alias ll='eza -laah --color=auto --group-directories-first'
    alias lt='eza --tree --color=auto --group-directories-first'
    alias lta='eza --tree -a --color=auto --group-directories-first'
else
    alias ls='ls --color=auto'
    alias l='ls -lh --color=auto'
    alias la='ls -lah --color=auto'
    alias ll='ls -laah --color=auto'
fi
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias mkdir='mkdir -p'
alias rmdir='rmdir --ignore-fail-on-non-empty'
if command -v bat >/dev/null 2>&1; then
    alias cat='bat --style=plain --color=auto'
fi
alias more='less -R'
if command -v rg >/dev/null 2>&1; then
    alias rg='rg --color=auto --line-number --hidden --smart-case'
    alias grep='rg --color=auto --line-number --hidden --smart-case'
    alias egrep='rg --color=auto --line-number --hidden --smart-case -E'
    alias fgrep='rg --color=auto --line-number --hidden --smart-case -F'
else
    alias grep='grep --color=auto'
    alias egrep='egrep --color=auto'
    alias fgrep='fgrep --color=auto'
fi
if command -v delta >/dev/null 2>&1; then
    alias diff='delta'
else
    alias diff='diff --color=auto'
fi
if command -v yazi >/dev/null 2>&1; then
    fm() {
        tmp="$(mktemp -t "yazi-cwd.XXXXXX")"; cwd=""
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
            builtin cd -- "$cwd"
        fi
        rm -f -- "$tmp"
    }
fi
if command -v lazygit >/dev/null 2>&1; then
    alias lg='lazygit'
fi
if command -v lazydocker >/dev/null 2>&1; then
    alias lzd='lazydocker'
fi
if command -v tmux >/dev/null 2>&1; then
    alias tm='tmux'
fi
if command -v tree >/dev/null 2>&1; then
    alias tree='tree -C'
fi
if command -v nvim >/dev/null 2>&1; then
    alias vim='nvim'
    export EDITOR=nvim
fi

# --- Tool Integrations ---
if command -v fzf >/dev/null 2>&1; then
    eval "$(fzf --zsh)"
    fg="#CBE0F0"
    bg="#011628"
    bg_highlight="#143652"
    purple="#B388FF"
    blue="#06BCE4"
    cyan="#2CF9ED"
    export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan} --bind='?:toggle-preview,ctrl-/:toggle-preview,shift-up:preview-up,shift-down:preview-down,shift-left:preview-page-up,shift-right:preview-page-down,ctrl-b:preview-page-up,ctrl-f:preview-page-down,ctrl-a:preview-top,ctrl-e:preview-bottom'"
    if command -v fd >/dev/null 2>&1; then
        export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
        _fzf_compgen_path() {
          fd --hidden --exclude .git . "$1"
        }
        _fzf_compgen_dir() {
          fd --type=d --hidden --exclude .git . "$1"
        }
    fi
    show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {} 2>/dev/null || cat {}; fi"
    export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview' --preview-window='right:50%:wrap'"
    export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always --level=2 {} 2>/dev/null || ls -la {}' --preview-window='right:50%:wrap'"
    _fzf_comprun() {
      local command=$1
      shift
      case "$command" in
        cd)           fzf --preview 'eza --tree --color=always --level=2 {} 2>/dev/null || ls -la {}' "$@" ;;
        export|unset) fzf --preview "eval 'echo ${}'"         "$@" ;;
        ssh)          fzf --preview 'dig {}'                   "$@" ;;
        *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
      esac
    }
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -la --color=always $realpath 2>/dev/null || ls -la $realpath'
    zstyle ':fzf-tab:*' fzf-bindings 'tab:accept'
    zstyle ':fzf-tab:*' accept-line enter
    zstyle ':fzf-tab:*' fzf-flags '--preview-window=right:50%:wrap'
    if [[ -f "$FZFGIT_HOME/fzf-git.sh" ]]; then
        # Function to source fzf-git with grep unaliased for its duration
        _fzf_git_wrapper() {
            unalias grep 2>/dev/null
            source "$FZFGIT_HOME/fzf-git.sh"
            # Optionally, re-alias grep after, but in zsh, aliases are not global, so this is safe
        }
        # Use the wrapper instead of direct source
        _fzf_git_wrapper
    fi
    bindkey '^[c' fzf-cd-widget
fi
if command -v thefuck >/dev/null 2>&1; then
    eval $(thefuck --alias tf)
fi
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init --cmd cd zsh)"
fi
