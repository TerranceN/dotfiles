eval %sh{kak-lsp --kakoune --session "$kak_session"}
hook global WinSetOption filetype=(gdscript) %{
  # set-option buffer lsp_snippet_support false
  # hook buffer InsertCompletionHide .* %{
  #   execute-keys "<backspace>"
  # }
}
#hook global WinSetOption filetype=(javascript|typescript|c-sharp|gdscript) %{
hook global WinSetOption filetype=(typescript|c-sharp|gdscript|terraform) %{
  #set global lsp_debug true
  lsp-enable-window
  lsp-auto-hover-enable
  set global lsp_hover_anchor true
  # lsp-inlay-hints-enable global
}
hook global InsertCompletionShow .* %{
    try %{
        exec -draft 'h<a-K>\h<ret>'
        map window insert <down> <c-n>
        map window insert <up> <c-p>
    }
}
hook global InsertCompletionHide .* %{
    unmap window insert <down> <c-n>
    unmap window insert <up> <c-p>
}

# # for lsp-inlay-hints-enable
# hook global BufSetOption filetype=(?:javascript|typescript) %{
#   set-option buffer lsp_servers %{
#     [typescript-language-server]
#       root_globs = ["package.json", "tsconfig.json", "jsconfig.json", ".git", ".hg"]
#       args = ["--stdio"]
#       settings_section = "_"
#     [typescript-language-server.settings._]
#       preferences.includeInlayParameterNameHints = "all"
#   }
# }

hook global BufSetOption filetype=(?:gdscript) %{
  set-option buffer lsp_language_id gdscript
  set-option buffer lsp_servers %{
    [gdscript]
      root_globs = [".import", "project.godot"]
      command = "gdlsp-proxy"
      # command = "netcat"
      args = ["localhost", "6005"]
  }
}

hook global BufSetOption filetype=(?:c-sharp) %{
  set-option buffer lsp_language_id c-sharp
  set-option buffer lsp_servers %{
    [c-sharp]
      root_globs = [".sln", ".csproj"]
      command = "omnisharp"
      args = ["-lsp"]
  }
}

hook global BufSetOption filetype=(?:terraform) %{
  set-option buffer lsp_language_id terraform
  set-option buffer lsp_servers %{
    [terraform]
      root_globs = [".git"]
      command = "terraform-ls"
      args = ["serve"]
  }
}

# Recreate these hooks so we can set typescript as just typescript, not typescriptreact
# Fixes https://github.com/kakoune-lsp/kakoune-lsp/issues/211 (at the cost of two tsservers running)
evaluate-commands %{
  remove-hooks global lsp-language-id
  hook -group lsp-language-id global BufSetOption filetype=(.*) %{
    set-option buffer lsp_language_id %val{hook_param_capture_1}
  }
  hook -group lsp-language-id global BufSetOption filetype=(?:c|cpp) %{
    set-option buffer lsp_language_id c_cpp
  }
  hook -group lsp-language-id global BufSetOption filetype=javascript %{
    evaluate-commands %sh{
      if [[ ${kak_buffile} == *.jsx ]]; then
        echo "set-option buffer lsp_language_id javascriptreact"
      else
        echo "set-option buffer lsp_language_id javascript"
      fi
    }
  }
  hook -group lsp-language-id global BufSetOption filetype=protobuf %{
    set-option buffer lsp_language_id proto
  }
  hook -group lsp-language-id global BufSetOption filetype=sh %{
    set-option buffer lsp_language_id shellscript
  }
  hook -group lsp-language-id global BufSetOption filetype=typescript %{
    evaluate-commands %sh{
      if [[ ${kak_buffile} == *.tsx ]]; then
        echo "set-option buffer lsp_language_id typescriptreact"
      else
        echo "set-option buffer lsp_language_id typescript"
      fi
    }
  }
}
