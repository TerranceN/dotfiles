hook global WinDisplay .* %{
  evaluate-commands %sh{
    buflist=()
    for cmd in ${kak_buflist}; do
      if [[ "$cmd" != "${kak_bufname}" ]]; then
        buflist+=( "$cmd" )
      fi
    done
    buflist+=( "${kak_bufname}" )
    echo "arrange-buffers ${buflist[@]}"
  }
}
