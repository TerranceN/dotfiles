plug "andreyorst/smarttab.kak" defer smarttab %{
  set-option global softtabstop %opt{tabstop}
} config %{
  define-command detect-indent %{
    evaluate-commands %sh{
      echo "evaluate-commands %{"
      if [ -f ${kak_buffile} ]; then
        tablines=$(rg --count --include-zero '^\t' ${kak_buffile})
        spacelines=$(rg --count --include-zero '^  ' ${kak_buffile})
        if [ "$tablines" -gt "$spacelines" ]; then
          echo "smarttab"
        else
          echo "expandtab"
        fi
      else
        # Not an openable buffile, default to spaces
        echo "expandtab"
      fi
      echo "}"
    }
  }
  hook global BufOpenFile .* detect-indent
  hook global BufNewFile  .* detect-indent
}
