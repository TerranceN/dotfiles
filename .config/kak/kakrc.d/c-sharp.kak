# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*[.](cs) %{
  set-option buffer filetype c-sharp
}

hook global BufCreate .*[.](csproj) %{
  set-option buffer filetype xml
}

hook global BufCreate .*[.](sln) %{
  set-option buffer filetype xml
}

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=c-sharp %<
    require-module c-sharp

    set-option window comment_line '//'
    set-option window comment_block_begin '/*'
    set-option window comment_block_end '*/'
    set-option window makecmd 'dotnet build'

    hook -group "c-sharp-insert" window InsertChar \n c-sharp-insert-on-newline
    hook -group "c-sharp-indent" window InsertChar \n c-sharp-indent-on-newline
    hook -group "c-sharp-indent" window InsertChar \{ c-sharp-indent-on-opening-curly-brace
    hook -group "c-sharp-indent" window InsertChar \} c-sharp-indent-on-closing-curly-brace

    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window c-sharp-.+ }
>

hook -group c-sharp-highlight global WinSetOption filetype=c-sharp %<
    add-highlighter window/c-sharp ref c-sharp
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/c-sharp }
>

provide-module c-sharp %§

# Highlighting for C#
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

add-highlighter "shared/c-sharp"               regions
add-highlighter "shared/c-sharp/code"          default-region group
add-highlighter "shared/c-sharp/shebang"       region ^#!  $                       fill meta
add-highlighter "shared/c-sharp/double_string" region '"'  (?<!\\)(\\\\)*"         fill string
add-highlighter "shared/c-sharp/comment_line"  region //   '$'                     fill comment
add-highlighter "shared/c-sharp/comment"       region /\*  \*/                     fill comment
add-highlighter shared/c-sharp/code/ regex %{\b(this|true|false|null)\b} 0:value
add-highlighter shared/c-sharp/code/ regex "\b(var|void|dynamic|string|int|char|decimal|bool|double|float|List|IList|Enumerable|IEnumerable)\b" 0:type
add-highlighter shared/c-sharp/code/ regex "\b(while|for|if|else|do|static|readonly|switch|case|default|class|interface|enum|break|continue|return|async|await|using|namespace|try|catch|throw|new|extends|implements|throws|instanceof|finally|as|get|set)\b" 0:keyword
add-highlighter shared/c-sharp/code/ regex "\b(final|public|protected|private|abstract)\b" 0:attribute

# Commands
# ‾‾‾‾‾‾‾‾

# "borrowed" from c-family

define-command -hidden c-sharp-indent-on-newline %< evaluate-commands -draft -itersel %<
    execute-keys <semicolon>
    try %<
        # if previous line is part of a comment, do nothing
        execute-keys -draft <a-?>/\*<ret> <a-K>^\h*[^/*\h]<ret>
    > catch %<
        # else if previous line closed a paren (possibly followed by words and a comment),
        # copy indent of the opening paren line
        execute-keys -draft kx 1s(\))(\h+\w+)*\h*(\;\h*)?(?://[^\n]+)?\n\z<ret> m<a-semicolon>J <a-S> 1<a-&>
    > catch %<
        # else indent new lines with the same level as the previous one
        execute-keys -draft K <a-&>
    >
    # remove previous empty lines resulting from the automatic indent
    try %< execute-keys -draft k x <a-k>^\h+$<ret> Hd >
    # indent after an opening brace or parenthesis at end of line
    try %< execute-keys -draft k x <a-k>[{(]\h*$<ret> j <a-gt> >
    # indent after a label
    try %< execute-keys -draft k x s[a-zA-Z0-9_-]+:\h*$<ret> j <a-gt> >
    # indent after a statement not followed by an opening brace
    try %< execute-keys -draft k x s\)\h*(?://[^\n]+)?\n\z<ret> \
                               <a-semicolon>mB <a-k>\A\b(if|for|while)\b<ret> <a-semicolon>j <a-gt> >
    try %< execute-keys -draft k x s \belse\b\h*(?://[^\n]+)?\n\z<ret> \
                               j <a-gt> >
    # deindent after a single line statement end
    try %< execute-keys -draft K x <a-k>\;\h*(//[^\n]+)?$<ret> \
                               K x s\)(\h+\w+)*\h*(//[^\n]+)?\n([^\n]*\n){2}\z<ret> \
                               MB <a-k>\A\b(if|for|while)\b<ret> <a-S>1<a-&> >
    try %< execute-keys -draft K x <a-k>\;\h*(//[^\n]+)?$<ret> \
                               K x s \belse\b\h*(?://[^\n]+)?\n([^\n]*\n){2}\z<ret> \
                               <a-S>1<a-&> >
    # deindent closing brace(s) when after cursor
    try %< execute-keys -draft x <a-k> ^\h*[})] <ret> gh / [})] <esc> m <a-S> 1<a-&> >
    # align to the opening parenthesis or opening brace (whichever is first)
    # on a previous line if its followed by text on the same line
    try %< evaluate-commands -draft %<
        # Go to opening parenthesis and opening brace, then select the most nested one
        try %< execute-keys [c [({],[)}] <ret> >
        # Validate selection and get first and last char
        execute-keys <a-k>\A[{(](\h*\S+)+\n<ret> <a-K>"(([^"]*"){2})*<ret> <a-K>'(([^']*'){2})*<ret> <a-:><a-semicolon>L <a-S>
        # Remove possibly incorrect indent from new line which was copied from previous line
        try %< execute-keys -draft , <a-h> s\h+<ret> d >
        # Now indent and align that new line with the opening parenthesis/brace
        execute-keys 1<a-&> &
     > >
> >

define-command -hidden c-sharp-indent-on-opening-curly-brace %[
    # align indent with opening paren when { is entered on a new line after the closing paren
    try %[ execute-keys -draft -itersel h<a-F>)M <a-k> \A\(.*\)\h*\n\h*\{\z <ret> <a-S> 1<a-&> ]
    # align indent with opening paren when { is entered on a new line after the else
    try %[ execute-keys -draft -itersel hK <a-x> s \belse\b\h*(?://[^\n]+)?\n\h*\{<ret> <a-S> 1<a-&> ]
]

define-command -hidden c-sharp-indent-on-closing-curly-brace %[
    # align to opening curly brace when alone on a line
    try %[
        # in case open curly brace follows a closing paren, align indent with opening paren
        execute-keys -itersel -draft <a-h><a-:><a-k>^\h+\}$<ret>hm <a-F>)M <a-k> \A\(.*\)\h\{.*\}\z <ret> <a-S>1<a-&>
    ] catch %[
        # otherwise align with open curly brace
        execute-keys -itersel -draft <a-h><a-:><a-k>^\h+\}$<ret>hm<a-S>1<a-&>
    ] catch %[]
]

define-command -hidden c-sharp-insert-on-newline %[ evaluate-commands -itersel -draft %[
    execute-keys <semicolon>
    try %[
        evaluate-commands -draft -save-regs '/"' %[
            # copy the commenting prefix
            execute-keys -save-regs '' k <a-x>1s^\h*(//+\h*)<ret> y
            try %[
                # if the previous comment isn't empty, create a new one
                execute-keys <a-x><a-K>^\h*//+\h*$<ret> j<a-x>s^\h*<ret>P
            ] catch %[
                # if there is no text in the previous comment, remove it completely
                execute-keys d
            ]
        ]
    ]
    try %[
        # if the previous line isn't within a comment scope, break
        execute-keys -draft k<a-x> <a-k>^(\h*/\*|\h+\*(?!/))<ret>

        # find comment opening, validate it was not closed, and check its using star prefixes
        execute-keys -draft <a-?>/\*<ret><a-H> <a-K>\*/<ret> <a-k>\A\h*/\*([^\n]*\n\h*\*)*[^\n]*\n\h*.\z<ret>

        try %[
            # if the previous line is opening the comment, insert star preceeded by space
            execute-keys -draft k<a-x><a-k>^\h*/\*<ret>
            execute-keys -draft i*<space><esc>
        ] catch %[
           try %[
                # if the next line is a comment line insert a star
                execute-keys -draft j<a-x><a-k>^\h+\*<ret>
                execute-keys -draft i*<space><esc>
            ] catch %[
                try %[
                    # if the previous line is an empty comment line, close the comment scope
                    execute-keys -draft k<a-x><a-k>^\h+\*\h+$<ret> <a-x>1s\*(\h*)<ret>c/<esc>
                ] catch %[
                    # if the previous line is a non-empty comment line, add a star
                    execute-keys -draft i*<space><esc>
                ]
            ]
        ]

        # trim trailing whitespace on the previous line
        try %[ execute-keys -draft s\h+$<ret> d ]
        # align the new star with the previous one
        execute-keys K<a-x>1s^[^*]*(\*)<ret>&
    ]
] ]

§
