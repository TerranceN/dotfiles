function nvm
   bass source $HOME/.nvm/nvm.sh --no-use ';' nvm $argv
end

nvm use default > /dev/null
