# ~/.zprofile - Login Shell Configuration
# echo "SOURCED ~/.zprofile (PID: $$)"

# Login Interactive Shell: ~/.zsh/env.zsh sourced from here
# Login Non-Interactive Shell: ~/.zsh/env.zsh sourced from here
# The guard will prevent sourcing it multiple times.
__ZSH_ENV="${HOME}/.zsh/env.zsh"
if [ -f "$__ZSH_ENV" ]; then
  source "$__ZSH_ENV"
fi

# SSH Agent: share one agent on a fixed socket instead of starting one per login shell.
# ssh-add -l exits 2 only when no agent answers on the socket.
if [ -z "$SSH_AUTH_SOCK" ]; then
  __SSH_AGENT_SOCK="${XDG_STATE_HOME:-$HOME/.local/state}/ssh-agent.sock"
  SSH_AUTH_SOCK="$__SSH_AGENT_SOCK" ssh-add -l >/dev/null 2>&1
  if [ $? -eq 2 ]; then
    mkdir -p "${__SSH_AGENT_SOCK%/*}"
    rm -f "$__SSH_AGENT_SOCK"
    ssh-agent -a "$__SSH_AGENT_SOCK" >/dev/null
  fi
  export SSH_AUTH_SOCK="$__SSH_AGENT_SOCK"
  unset __SSH_AGENT_SOCK
fi
