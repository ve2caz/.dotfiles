# ~/.zprofile - Login Shell Configuration
# echo "SOURCED ~/.zprofile (PID: $$)"

# Login Interactive Shell: ~/.zsh/env.zsh sourced from here
# Login Non-Interactive Shell: ~/.zsh/env.zsh sourced from here
# The guard will prevent sourcing it multiple times.
__ZSH_ENV="${HOME}/.zsh/env.zsh"
if [ -f "$__ZSH_ENV" ]; then
  source "$__ZSH_ENV"
fi

# User's preferred language/region (after system defaults from env.zsh)
# This will be enhanced to UTF-8 by .zshrc later
export LANG="en_US"

# SSH Agent
if [ -z "$SSH_AUTH_SOCK" ]; then
  eval "$(ssh-agent -s)"
fi
