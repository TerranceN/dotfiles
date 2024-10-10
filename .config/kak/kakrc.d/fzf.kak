# Define these as separate commands so we can override the history file per operation
define-command fzf-grep-with-hist -params 0..1 %{
  require-module fzf
  require-module fzf-grep

  set-option global fzf_implementation %sh{
    histfile=/home/terrance/.sk_kak_grep_history
    if [[ "$1" == "prefill" ]]; then
      prefill="--query='$(tail -n 1 $histfile)'"
    fi
    echo "sk --history=$histfile $prefill"
  }
  fzf-grep
}
define-command fzf-file-with-hist -params 0..1 %{
  require-module fzf
  require-module fzf-file

  set-option global fzf_implementation %sh{
    histfile=/home/terrance/.sk_kak_file_history
    if [[ "$1" == "prefill" ]]; then
      prefill="--query='$(tail -n 1 $histfile)'"
    fi
    echo "sk --history=$histfile $prefill"
  }
  fzf-file
}
define-command fzf-buffer-open %{
  require-module fzf
  require-module fzf-buffer

  set-option global fzf_implementation 'sk'
  fzf-buffer
}

plug "andreyorst/fzf.kak" config %{
  map global normal <c-p> ': fzf-mode<ret>'
  map global user f ':fzf-file-with-hist<ret>'
  map global user F ':fzf-file-with-hist prefill<ret>'
  map global user g ':fzf-grep-with-hist<ret>'
  map global user G ':fzf-grep-with-hist prefill<ret>'
  map global user b ':fzf-buffer-open<ret>'
} defer fzf %{
  set-option global fzf_implementation 'sk'
  set-option global fzf_use_main_selection false
} defer fzf-file %{
  set-option global fzf_file_command 'rg'
  set-option global fzf_highlight_command 'bat'
} defer fzf-grep %{
  set-option global fzf_grep_command 'rg'
  set-option global fzf_grep_preview_command 'bat'
}
