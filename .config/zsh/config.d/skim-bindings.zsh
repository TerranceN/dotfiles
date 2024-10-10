if [ -f /usr/share/skim/key-bindings.zsh ]; then
  source /usr/share/skim/key-bindings.zsh
  # source /usr/share/skim/completion.zsh

  if [ $(command -v zvm_define_widget) ]; then
    skim-history-widget-then-ins() {
      zle history-search-forwards
      zle skim-history-widget
      zvm_append_eol
    }

    zvm_define_widget skim-history-widget-then-ins

    zvm_bindkey viins '\e/' skim-history-widget
    zvm_bindkey vicmd '/' skim-history-widget-then-ins
  fi

  export SKIM_DEFAULT_OPTIONS="--history=$HOME/.skim_history"

  skim_fn() {
    print -z "$(history | sk --tac --no-sort --exact | awk '{for (i=2; i<NF; i++) printf $i " "; print $NF}')"
  }

  setopt histignorealldups
  alias f=skim_fn
fi
