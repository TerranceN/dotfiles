map -docstring "git blame"      global user l ":git blame<ret>"
map -docstring "git blame-jump" global user L ":git blame-jump<ret>"

map -docstring "git next-hunk" global normal <c-n> ":git next-hunk<ret>"
map -docstring "git prev-hunk" global normal <c-a-n> ":git prev-hunk<ret>"

# enable flag-lines hl for git diff
hook global WinCreate .* %{
    add-highlighter window/git-diff flag-lines Default git_diff_flags
}
# trigger update diff if inside git dir
hook global BufOpenFile .* %{
    evaluate-commands -draft %sh{
        cd $(dirname "$kak_buffile")
        if [ $(git rev-parse --git-dir 2>/dev/null) ]; then
            for hook in WinCreate BufReload BufWritePost; do
                printf "hook buffer -group git-update-diff %s .* 'git update-diff'\n" "$hook"
            done
        fi
    }
}
