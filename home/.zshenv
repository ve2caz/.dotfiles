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
# A parent can put folders in front of PATH on purpose: a Python venv, direnv's PATH_add, an IDE
# terminal. path_helper below moves them behind the system folders; env.zsh puts them back.
_zsh_inherited_path=( $path )

# Work around for macOS path_helper
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
      # System-wide login profile (e.g. path defaults). User ~/.zprofile runs later in startup.
      # Same ordering for interactive and non-interactive login shells.
      # It also sets LANG=C.UTF-8 when LANG is empty, which drops the region: leave LANG empty
      # instead, and ensure_utf8_locale sets it from the region as in non-login shells.
      _zsh_lang=${LANG-}
      source /etc/zprofile
      [[ -z $_zsh_lang && $LANG == C.UTF-8 ]] && unset LANG
      unset _zsh_lang
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
