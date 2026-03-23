# Session type: non-interactive non-login shell
# Arguments:
#   env -i : run with an empty inherited environment
#   zsh -c : execute the command string and exit
#   (no -i) : keep shell non-interactive
#   (no -l) : do not load login-shell startup flow
env -i zsh  -c 'echo $PATH | tr ":" "\n"'
