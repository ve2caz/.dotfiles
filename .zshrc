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

# Add in snippets
zinit snippet OMZP::command-not-found

# Load completions
autoload -U compinit && compinit
zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

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

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias cls='clear'
alias ls="eza --color=always"
alias l='eza -lh --color=always'
alias la='eza -lah --color=always'
alias ll='eza -laah --color=always'
alias vim='nvim'

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
