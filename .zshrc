# VS Code shell integration - Load early to avoid conflicts with prompt
if [[ "$TERM_PROGRAM" == "vscode" ]]; then
    # Disable Powerlevel10k instant prompt in VS Code to prevent conflicts
    POWERLEVEL9K_INSTANT_PROMPT=off
    # Load VS Code shell integration
    if command -v code >/dev/null 2>&1; then
        local vscode_shell_integration="$(code --locate-shell-integration-path zsh 2>/dev/null)"
        if [[ -r "$vscode_shell_integration" ]]; then
            source "$vscode_shell_integration"
        fi
    fi
    # Alternative: Set shell integration environment variables manually if automatic detection fails
    export VSCODE_SHELL_INTEGRATION=1
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# Disable instant prompt in VS Code to avoid shell integration conflicts
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]] && [[ "$TERM_PROGRAM" != "vscode" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Zinit is a flexible and fast Zshell plugin manager.
# Installation is handled by install-packages.sh script
# Set the directory to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME}/zinit/zinit.git"
source "${ZINIT_HOME}/zinit.zsh"

# TPM (Tmux Plugin Manager) is a plugin manager for tmux.
# Installation is handled by install-packages.sh script
# Set the directory for tpm (tmux plugin manager)
TPM_HOME="${XDG_DATA_HOME}/tmux/plugins/tpm"

# fzf-git is a collection of bash/zsh key bindings for Git that use fzf.
# Installation is handled by install-packages.sh script
# Set the directory to store fzf-git
FZFGIT_HOME="${XDG_DATA_HOME}/fzf-git"

# bat is a cat clone with syntax highlighting and Git integration.
# Theme installation is handled by setup-tokyo-night-theme.sh script

# Add Powerlevel10k prompts
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add zsh plugins
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light Aloxaf/fzf-tab

# Add Oh My Zsh plugins
#   Web search plugin - provides shortcuts for searching various websites:
#   - google <query> - Search Google
#   - github - Open GitHub
#   - stackoverflow <query> - Search Stack Overflow
#   - youtube <query> - Search YouTube
#   - wiki <query> - Search Wikipedia
#   - ddg <query> - Search DuckDuckGo
zinit light sinetoami/web-search

# Load tab completions
autoload -U compinit && compinit
zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.config/p10k/config.zsh.
[[ ! -f "${XDG_CONFIG_HOME}/p10k/config.zsh" ]] || source "${XDG_CONFIG_HOME}/p10k/config.zsh"

# Keybindings
bindkey -e                                                               # Use Emacs-style key bindings
bindkey '^p' history-search-backward                                     # Ctrl+P: Search backward in history
bindkey '^n' history-search-forward                                      # Ctrl+N: Search forward in history  
bindkey '^[w' kill-region                                                # Alt+W: Cut/kill selected region

# History
HISTFILE="${XDG_DATA_HOME}/zsh/history"                                  # File to save command history (XDG compliant)
HISTSIZE=5000                                                            # Number of commands to keep in memory
SAVEHIST=$HISTSIZE                                                       # Number of commands to save to HISTFILE
HISTDUP=erase                                                            # Remove older duplicate commands from history
setopt appendhistory                                                     # Append new history lines to HISTFILE, not overwrite
setopt sharehistory                                                      # Share history across all zsh sessions
setopt hist_ignore_space                                                 # Ignore commands that start with a space
setopt hist_ignore_all_dups                                              # Remove all previous duplicates in history
setopt hist_save_no_dups                                                 # Don't write duplicate commands to HISTFILE
setopt hist_ignore_dups                                                  # Ignore duplicate commands entered consecutively
setopt hist_find_no_dups                                                 # Don't show duplicates when searching history

# Pager Configuration
# - Enhanced file viewing with syntax highlighting and color support
export LESS='-R'                                                         # Display colors correctly
if command -v bat >/dev/null 2>&1; then
    export BAT_THEME=tokyonight_night                                    # Set bat theme to Tokyo Night
    export LESSOPEN='|bat --color=always %s'                             # Use bat for syntax highlighting in less
fi
export PAGER='less -R'                                                   # Set less as default pager with color support

# Set up colors for ls/eza and completions
if command -v dircolors >/dev/null 2>&1; then
    eval "$(dircolors -b)"                                               # Load LS_COLORS from dircolors (Linux/GNU coreutils)
elif command -v gdircolors >/dev/null 2>&1; then
    eval "$(gdircolors -b)"                                              # Load LS_COLORS from gdircolors (MacOS via GNU coreutils from Homebrew)
else
    # Enhanced LS_COLORS for MacOS with more file types
    export LS_COLORS='di=1;34:ln=1;36:so=1;35:pi=1;33:ex=1;32:bd=1;33:cd=1;33:su=1;31:sg=1;31:tw=1;34:ow=1;34:*.tar=1;31:*.tgz=1;31:*.zip=1;31:*.gz=1;31:*.bz2=1;31:*.xz=1;31:*.lz=1;31:*.jpg=1;35:*.jpeg=1;35:*.png=1;35:*.gif=1;35:*.svg=1;35:*.pdf=1;31:*.doc=1;31:*.docx=1;31:*.xls=1;31:*.xlsx=1;31:*.ppt=1;31:*.pptx=1;31:*.mp3=1;36:*.mp4=1;36:*.avi=1;36:*.mkv=1;36:*.mov=1;36:*.js=1;33:*.ts=1;33:*.py=1;33:*.rb=1;33:*.go=1;33:*.rs=1;33:*.cpp=1;33:*.c=1;33:*.h=1;33:*.css=1;33:*.html=1;33:*.json=1;33:*.xml=1;33:*.yml=1;33:*.yaml=1;33'
fi

# Set EZA_COLORS to match LS_COLORS for consistency
export EZA_COLORS=$LS_COLORS

# Completion styling - minimal setup for fzf-tab
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'                   # Case-insensitive tab completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"                  # Use LS_COLORS for completion list coloring

#
# Aliases - Enhanced command replacements and shortcuts
#

# System shortcuts
alias cls='clear'                                                        # Clear screen shortcut

# File listing with eza (modern ls replacement) - Only if eza is available
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --color=auto --group-directories-first'                # Basic listing with auto color, directories first
    alias l='eza -lh --color=auto --group-directories-first'             # Long format including hidden files
    alias la='eza -lah --color=auto --group-directories-first'           # Long format including hidden files
    alias ll='eza -laah --color=auto --group-directories-first'          # Long format with all details and hidden files
    alias lt='eza --tree --color=auto --group-directories-first'         # Tree view of directory structure
    alias lta='eza --tree -a --color=auto --group-directories-first'     # Tree view including hidden files
else
    # Fallback to standard ls with basic colors
    alias ls='ls --color=auto'
    alias l='ls -lh --color=auto'
    alias la='ls -lah --color=auto'
    alias ll='ls -laah --color=auto'
fi

# File and directory operations with safety prompts
alias cp='cp -i'                                                         # Prompt before overwriting files when copying
alias mv='mv -i'                                                         # Prompt before overwriting files when moving
alias rm='rm -i'                                                         # Prompt before deleting files for safety
alias mkdir='mkdir -p'                                                   # Create parent directories automatically if needed
alias rmdir='rmdir --ignore-fail-on-non-empty'                           # Remove directories, ignore if not empty

# File viewing and content display
if command -v bat >/dev/null 2>&1; then
    alias cat='bat --style=plain --color=auto'                           # Enhanced cat with syntax highlighting via bat
fi
alias more='less -R'                                                     # Use less with color support instead of more

# Text processing and search commands with color support  
alias grep='grep --color=auto'                                           # Enable colored output for grep
alias egrep='egrep --color=auto'                                         # Enable colored output for extended grep
alias fgrep='fgrep --color=auto'                                         # Enable colored output for fixed string grep
alias diff='diff --color=auto'                                           # Enable colored output for diff

# Development tooling - Only alias if tools are available
if command -v yazi >/dev/null 2>&1; then
    function fm() {                                                      # Use yazi for file management
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
            builtin cd -- "$cwd"
        fi
        rm -f -- "$tmp"
    }
fi
if command -v lazygit >/dev/null 2>&1; then
    alias lg='lazygit'                                                   # Use lazygit for git operations
fi
if command -v lazydocker >/dev/null 2>&1; then
    alias lzd='lazydocker'                                               # Use lazydocker for docker operations
fi
if command -v tmux >/dev/null 2>&1; then
    alias tm='tmux'                                                      # Use tm as shortcut for tmux
fi
if command -v tree >/dev/null 2>&1; then
    alias tree='tree -C'                                                 # Force colored output for tree command even when piping
fi
if command -v nvim >/dev/null 2>&1; then
    alias vim='nvim'                                                     # Use neovim instead of vim
    export EDITOR=nvim
fi

# Shell integrations - Initialize tools first, then configure
if command -v fzf >/dev/null 2>&1; then
    eval "$(fzf --zsh)"                                                  # Enable fzf shell integration for zsh (fuzzy finder)
    
    # fzf custom theme - Configure after fzf is initialized
    fg="#CBE0F0"
    bg="#011628"
    bg_highlight="#143652"
    purple="#B388FF"
    blue="#06BCE4"
    cyan="#2CF9ED"
    export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan} --bind='?:toggle-preview,ctrl-/:toggle-preview,shift-up:preview-up,shift-down:preview-down,shift-left:preview-page-up,shift-right:preview-page-down,ctrl-b:preview-page-up,ctrl-f:preview-page-down,ctrl-a:preview-top,ctrl-e:preview-bottom'"

    # Use fd instead of find in fzf for better performance and usability
    # fd is a simple, fast and user-friendly alternative to find.
    if command -v fd >/dev/null 2>&1; then
        export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

        # Use fd for listing path candidates.
        # - The first argument to the function ($1) is the base path to start traversal
        _fzf_compgen_path() {
          fd --hidden --exclude .git . "$1"
        }

        # Use fd to generate the list for directory completion
        _fzf_compgen_dir() {
          fd --type=d --hidden --exclude .git . "$1"
        }
    fi

    # fzf preview options for built-in commands
    show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {} 2>/dev/null || cat {}; fi"
    
    export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview' --preview-window='right:50%:wrap'"
    export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always --level=2 {} 2>/dev/null || ls -la {}' --preview-window='right:50%:wrap'"

    # Advanced customization of fzf options via _fzf_comprun function
    # - The first argument to the function is the name of the command.
    # - You should make sure to pass the rest of the arguments to fzf.
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
    
    # fzf-tab configuration - Configure after fzf is initialized
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -la --color=always $realpath 2>/dev/null || ls -la $realpath'  # Colored preview for directories
    zstyle ':fzf-tab:*' fzf-bindings 'tab:accept'                        # Tab accepts selection but doesn't execute
    zstyle ':fzf-tab:*' accept-line enter                                # Only Enter executes the command
    zstyle ':fzf-tab:*' fzf-flags '--preview-window=right:50%:wrap'      # Set preview window position and wrapping
    
    # Load fzf-git key bindings for Git operations - Load after fzf is initialized
    if [[ -f "$FZFGIT_HOME/fzf-git.sh" ]]; then
        source "$FZFGIT_HOME/fzf-git.sh"
    fi
    
    # Ensure Alt-C binding is properly set (sometimes needed on certain terminals)
    bindkey '^[c' fzf-cd-widget                                          # Alt+C: Directory navigation with fzf
fi

if command -v thefuck >/dev/null 2>&1; then
    eval $(thefuck --alias tf)                                           # Enable thefuck command correction (use 'tf' after wrong command)
fi

if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init --cmd cd zsh)"                                   # Enable zoxide integration with 'cd' command in zsh (smart directory jumping)
fi
