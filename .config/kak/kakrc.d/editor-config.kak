# Disable clippy
set global ui_options terminal_assistant=none

# Relative line numbers
add-highlighter global/ number-lines -relative -hlcursor
# Highlight matching brackets
add-highlighter global/ show-matching
# Whitespace
add-highlighter global/ show-whitespaces
add-highlighter global/ wrap

# Tabs and spaces
set global tabstop 2
set global indentwidth 2

# Keep a margin around the cursor by autoscrolling
set-option global scrolloff 8,3

# Automatically reload files if they changed outside of kakoune
set global autoreload true

# Default keybinds
map -docstring "line begin"    global goto <left> h
map -docstring "buffer bottom" global goto <down> j
map -docstring "buffer top"    global goto <up> k
map -docstring "line end"      global goto <right> l

map -docstring "yank to system clipboard" global user y <a-|>wl-copy<ret>
map -docstring "last buffer" global user <tab> ga
map -docstring "comment line" global user / ":comment-line<ret>"
map -docstring "comment block" global user ? ":comment-block<ret>"
