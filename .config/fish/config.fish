# set PATH so it includes user's private bin if it exists
set PATH $PATH "$HOME/bin"

# set PATH so it includes user's private bin if it exists
set PATH $PATH "$HOME/.local/bin"

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
