Dotfiles
========

First time setup:
-----------------

```
mkdir $HOME/.dotfiles
git init --bare $HOME/.dotfiles
```

```
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

```
dotfiles config --local status.showUntrackedFiles no
dotfiles remote add origin git@github.com:TerranceN/dotfiles.git
```

New computer setup:
-------------------

Note: install oh-my-zsh first, as it overwrites `.zshrc`

```
git clone --separate-git-dir=$HOME/.dotfiles git@github.com:TerranceN/dotfiles.git tmpdotfiles
rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME/
rm -r tmpdotfiles

dotfiles config --local status.showUntrackedFiles no
```
