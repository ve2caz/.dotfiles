# Session type: interactive login shell
# Arguments:
#   env -i : run with an empty inherited environment
#   zsh -i : force interactive shell mode
#   zsh -l : force login shell mode
#   zsh -c : execute the command string and exit
env -i zsh -i -l -c 'echo $PATH | tr ":" "\n"'
