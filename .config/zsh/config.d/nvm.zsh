if [ -f $HOME/.nvm/nvm.sh ]; then
	source $HOME/.nvm/nvm.sh --no-use ';' nvm $argv
	export PATH="$PATH:$HOME/.nvm/versions/node/v20.18.0/bin/"
fi

if [ -f /usr/share/nvm/init-nvm.sh ]; then
	source /usr/share/nvm/init-nvm.sh
	export PATH="$PATH:$HOME/.nvm/versions/node/v20.18.0/bin/"
fi
