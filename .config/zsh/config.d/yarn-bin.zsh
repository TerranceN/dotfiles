if command -v yarn 2>&1 >/dev/null
then
  export PATH="$PATH:$(yarn global bin)"
fi
