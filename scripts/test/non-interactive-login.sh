# Session type: non-interactive login shell
# Arguments:
#   env -i : run with an empty inherited environment
#   zsh -l : force login shell mode
#   zsh -c : execute the command string and exit
#   (no -i) : keep shell non-interactive
env -i zsh -l -c 'echo $PATH | tr ":" "\n"'
