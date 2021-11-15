# set PATH so it includes user's private bin if it exists
set PATH $PATH "$HOME/bin"

# set PATH so it includes user's private bin if it exists
set PATH $PATH "$HOME/.local/bin"

set PATH $PATH "$HOME/tfenv/bin"

set PATH $PATH "$HOME/.cargo/bin"

set PATH $PATH "$HOME/.npm/bin"

bind \cd delete-char

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias v=nvim
alias asdf=fzf-history-widget
alias tf=terraform
alias f=fzf-history-widget
alias b='git brs'

set EDITOR nvim
