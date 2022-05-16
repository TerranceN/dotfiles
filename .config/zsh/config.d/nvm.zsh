if [ -f $NVM_DIR/nvm.sh ]; then
	source $NVM_DIR/nvm.sh --no-use ';' nvm $argv
	export PATH="$PATH:$NVM_DIR/versions/node/v16.14.0/bin/"
fi
