# ~/.zshenv - ALL shells (Login, Non-login, Interactive, Non-interactive)
# echo "SOURCED ~/.zshenv (PID: $$)"

# Ref: https://gist.github.com/Linerre/f11ad4a6a934dcf01ee8415c9457e7b2
# --- cat /etc/zprofile ---
# # System-wide profile for interactive zsh(1) login shells.
#
# # Setup user specific overrides for this in ~/.zprofile. See zshbuiltins(1)
# # and zshoptions(1) for more details.
#
# if [ -x /usr/libexec/path_helper ]; then
#   eval `/usr/libexec/path_helper -s`
# fi
# -------------------------
#
# Work around for macOS path_helper
# (Linux doesn't have this problem!)
if [[ "$OSTYPE" == darwin* ]]; then
  # Prevent /etc/zprofile and /etc/zshrc from loading automatically
  unsetopt GLOBAL_RCS

  # Let path_helper set up the initial PATH
  if [ -x /usr/libexec/path_helper ]; then
    eval `/usr/libexec/path_helper -s`
  fi

  # On newer macOS /etc/zshenv no longer exists by default, but check anyway
  # To avoid recursion, only source /etc/zshenv if it doesn't try to source ~/.zshenv
  if [ -f /etc/zshenv ] && ! grep -q '~/.zshenv\|$HOME/.zshenv' /etc/zshenv; then
    source /etc/zshenv
  fi

  # Only source /etc/zprofile for login shells
  if [[ -o login ]]; then
    if [ -f /etc/zprofile ]; then
      # Login Interactive Shell: ~/.zsh/env.zsh ran from .zprofile
      # Login Non-Interactive Shell: ~/.zsh/env.zsh ran from .zprofile
      source /etc/zprofile
    fi
  fi
fi

# Non-Login Interactive Shell: ~/.zsh/env.zsh sourced from here
# Non-Login Non-Interactive Shell: ~/.zsh/env.zsh sourced from here
# The guard will prevent sourcing it multiple times.
__ZSH_ENV="${HOME}/.zsh/env.zsh"
if [ -f "$__ZSH_ENV" ]; then
  source "$__ZSH_ENV"
fi
