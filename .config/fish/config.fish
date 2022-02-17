# set PATH so it includes user's private bin if it exists
set PATH $PATH "$HOME/bin"

# set PATH so it includes user's private bin if it exists
set PATH $PATH "$HOME/.local/bin"

set PATH $PATH "$HOME/tfenv/bin"

set PATH $PATH "$HOME/.cargo/bin"

set PATH $PATH "$HOME/.npm/bin"

bind \cd delete-char

if type -q fzf_key_bindings
	fzf_key_bindings
end

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias v=nvim
alias tf=terraform
alias f=fzf-history-widget
alias g=git
alias b='git brs'

set EDITOR nvim
