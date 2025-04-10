if [ -f /usr/share/fzf/key-bindings.zsh ]; then
  source /usr/share/fzf/key-bindings.zsh
  source /usr/share/fzf/completion.zsh

  if [ $(command -v zvm_define_widget) ]; then
    fzf-history-widget-then-ins() {
      zle history-search-forwards
      zle fzf-history-widget
      zvm_append_eol
    }

    zvm_define_widget fzf-history-widget-then-ins

    zvm_bindkey viins '\e/' fzf-history-widget
    zvm_bindkey vicmd '/' fzf-history-widget-then-ins
  fi

  export FZF_DEFAULT_OPTS="--history=$HOME/.fzf_history"

  fzf_fn() {
    print -z "$(history | fzf --tac --tiebreak=index | sed 's/\\/\\\\/g' | awk '{for (i=2; i<NF; i++) printf $i " "; print $NF}')"
  }

  setopt histignorealldups
  alias f=fzf_fn
fi
