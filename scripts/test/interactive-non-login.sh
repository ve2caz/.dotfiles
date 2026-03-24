# Session type: interactive non-login shell
# Arguments:
#   env -i : run with an empty inherited environment
#   zsh -i : force interactive shell mode
#   zsh -c : execute the command string and exit
#   (no -l) : do not load login-shell startup flow
env -i zsh -i -c 'echo $PATH | tr ":" "\n"'
