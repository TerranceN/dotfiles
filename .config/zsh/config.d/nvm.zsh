if [ -f $HOME/.nvm/nvm.sh ]; then
	source $HOME/.nvm/nvm.sh --no-use ';' nvm $argv
	export PATH="$PATH:$HOME/.nvm/versions/node/v16.14.0/bin/"
fi
