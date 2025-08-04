# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Zinit is a flexible and fast Zshell plugin manager.
# It allow you to install everything from GitHub and other sites.
# Set the directory to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
	mkdir -p "$(dirname $ZINIT_HOME)"
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add zsh plugins
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light Aloxaf/fzf-tab

# Load completions
autoload -U compinit && compinit
zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
bindkey -e                               # Use Emacs-style key bindings
bindkey '^p' history-search-backward     # Ctrl+P: Search backward in history
bindkey '^n' history-search-forward      # Ctrl+N: Search forward in history  
bindkey '^[w' kill-region                # Alt+W: Cut/kill selected region
bindkey '^I' fzf-tab-complete            # Tab: Use fzf-tab for completion
bindkey '^[[Z' reverse-menu-complete     # Shift+Tab: Reverse completion navigation

# History
HISTFILE=~/.zsh_history         # File to save command history
HISTSIZE=5000                   # Number of commands to keep in memory
SAVEHIST=$HISTSIZE              # Number of commands to save to HISTFILE
HISTDUP=erase                   # Remove older duplicate commands from history
setopt appendhistory            # Append new history lines to HISTFILE, not overwrite
setopt sharehistory             # Share history across all zsh sessions
setopt hist_ignore_space        # Ignore commands that start with a space
setopt hist_ignore_all_dups     # Remove all previous duplicates in history
setopt hist_save_no_dups        # Don't write duplicate commands to HISTFILE
setopt hist_ignore_dups         # Ignore duplicate commands entered consecutively
setopt hist_find_no_dups        # Don't show duplicates when searching history

# Environment Variables
export LESS='-R'                                   # Display colors correctly
export LESSOPEN='|[[ $(file -b %s) =~ ^text ]] && bat --color=always %s || command cat %s'
export PAGER='less -R'                             # Set less as default pager with color support

# Set up colors for ls/eza and completions
if command -v dircolors >/dev/null 2>&1; then
    eval "$(dircolors -b)"          # Load LS_COLORS from dircolors (Linux/GNU coreutils)
elif command -v gdircolors >/dev/null 2>&1; then
    eval "$(gdircolors -b)"         # Load LS_COLORS from gdircolors (macOS via GNU coreutils from Homebrew)
else
    # Enhanced LS_COLORS for macOS with more file types
    export LS_COLORS='di=1;34:ln=1;36:so=1;35:pi=1;33:ex=1;32:bd=1;33:cd=1;33:su=1;31:sg=1;31:tw=1;34:ow=1;34:*.tar=1;31:*.tgz=1;31:*.zip=1;31:*.gz=1;31:*.bz2=1;31:*.xz=1;31:*.lz=1;31:*.jpg=1;35:*.jpeg=1;35:*.png=1;35:*.gif=1;35:*.svg=1;35:*.pdf=1;31:*.doc=1;31:*.docx=1;31:*.xls=1;31:*.xlsx=1;31:*.ppt=1;31:*.pptx=1;31:*.mp3=1;36:*.mp4=1;36:*.avi=1;36:*.mkv=1;36:*.mov=1;36:*.js=1;33:*.ts=1;33:*.py=1;33:*.rb=1;33:*.go=1;33:*.rs=1;33:*.cpp=1;33:*.c=1;33:*.h=1;33:*.css=1;33:*.html=1;33:*.json=1;33:*.xml=1;33:*.yml=1;33:*.yaml=1;33'
fi

# Set EZA_COLORS to match LS_COLORS for consistency
export EZA_COLORS=$LS_COLORS

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'               # Case-insensitive tab completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"              # Use LS_COLORS for completion list coloring
zstyle ':completion:*' menu no                                       # Disable completion menu selection
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --color=always --long --no-permissions --no-user --no-time $realpath 2>/dev/null || eza --color=always $realpath'

# fzf-tab configuration for better navigation
zstyle ':fzf-tab:*' fzf-command fzf                          # Use standard fzf (more compatible than tmux popup)
zstyle ':fzf-tab:*' fzf-bindings 'tab:accept'                        # Accept with tab instead of enter
zstyle ':fzf-tab:*' accept-line enter                                # Use enter for accept-line
zstyle ':fzf-tab:*' continuous-trigger '/'                           # Continue completion after '/'
zstyle ':fzf-tab:*' fzf-min-height 15                                # Minimum height for fzf window

# Aliases - Enhanced command replacements and shortcuts

# System shortcuts
alias cls='clear'                                                    # Clear screen shortcut

# File listing with eza (modern ls replacement)
alias ls='eza --color=always --group-directories-first'              # Basic listing with colors, directories first
alias l='eza -lh --color=always --group-directories-first'           # Long format with human-readable sizes
alias la='eza -lah --color=always --group-directories-first'         # Long format including hidden files
alias ll='eza -laah --color=always --group-directories-first'        # Long format with all details and hidden files
alias lt='eza --tree --color=always --group-directories-first'       # Tree view of directory structure
alias lta='eza --tree -a --color=always --group-directories-first'   # Tree view including hidden files

# File and directory operations with safety prompts
alias cp='cp -i'                                                     # Prompt before overwriting files when copying
alias mv='mv -i'                                                     # Prompt before overwriting files when moving
alias rm='rm -i'                                                     # Prompt before deleting files for safety
alias mkdir='mkdir -p'                                               # Create parent directories automatically if needed
alias rmdir='rmdir --ignore-fail-on-non-empty'                       # Remove directories, ignore if not empty

# File viewing and content display
alias cat='bat --style=plain --color=auto'                           # Enhanced cat with syntax highlighting via bat
alias more='less -R'                                                 # Use less with color support instead of more

# Text processing and search commands with color support  
alias grep='grep --color=auto'                                       # Enable colored output for grep
alias egrep='egrep --color=auto'                                     # Enable colored output for extended grep
alias fgrep='fgrep --color=auto'                                     # Enable colored output for fixed string grep
alias diff='diff --color=auto'                                       # Enable colored output for diff

# Editor preferences
alias vim='nvim'                                                     # Use neovim instead of vim

# Shell integrations - with error checking
if command -v fzf >/dev/null 2>&1; then
    eval "$(fzf --zsh)"                # Enable fzf shell integration for zsh (fuzzy finder)
fi

if command -v thefuck >/dev/null 2>&1; then
    eval $(thefuck --alias tf)         # Enable thefuck command correction (use 'tf' after wrong command)
fi

if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init --cmd cd zsh)" # Enable zoxide integration with 'cd' command in zsh (smart directory jumping)
fi
