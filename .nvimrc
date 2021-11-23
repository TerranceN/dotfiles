let mapleader =" "

let $FZF_DEFAULT_COMMAND = 'rg --files --hidden'

call plug#begin('~/.config/nvim/plugged')

Plug 'tpope/vim-sensible'
Plug 'micha/wombat256'
Plug 'tpope/vim-surround'
Plug 'roryokane/detectindent'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'vim-airline/vim-airline'

Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

Plug 'mbbill/undotree'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

"" My favourite colorscheme
colorscheme wombat256mod

"" Use patched powerline fonts (google powerline fonts or nerdline fonts)
let g:airline_powerline_fonts = 1

"" Default to two-space-width tabs
set tabstop=2
set shiftwidth=2

"" Allow hidden buffers
set hidden

"" Normal line number on selected line, relative line numbers everywhere else
set nu
set rnu

"" Highlight the current line
set cursorline

"" GitGutter colors aren't set by wombat256mod, so set them manually
highlight SignColumn guibg=#242424 ctermbg=234
highlight GitGutterAdd    guifg=#95e454 ctermfg=113
highlight GitGutterChange guifg=#bbbb00 ctermfg=3
highlight GitGutterDelete guifg=#e5786d ctermfg=173

"" Update gutter every 100ms (defaults to like 5s or something kinda long)
set updatetime=100

"" Always show the sign column
:set signcolumn=yes

"" Hotkey to toggle GitGutter, but by default turn it on when opening a file
nnoremap <silent> <leader>d :GitGutterToggle<CR>
augroup GitGutter
   autocmd!
   autocmd BufReadPost *  GitGutterEnable
augroup END

"" Auto-detect indent settings when loading a file
augroup DetectIndent
   autocmd!
   autocmd BufReadPost *  DetectIndent
augroup END

"" Shortcut for :
nnoremap <silent> <leader><leader> :

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case --hidden -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

"" FileFind and FileGrep
nnoremap <silent> <leader>f :Files<CR>
nnoremap <silent> <leader>g :RG<CR>

"" Buffer switching
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader><Tab> :b#<CR>

"" Explore shortcut
nnoremap <silent> <leader>e :Ex<CR>

"" Select most recently pasted block (useful for pasting and then copying that thing again)
nnoremap gp `[v`]

"" Hotkey for toggling undo-tree
nnoremap <silent> <leader>u :UndotreeToggle<CR><C-w><left>

"" Save persistent undo files
silent !mkdir ~/.vim/undodir > /dev/null 2>&1
set undodir=~/.vim/undodir
set undofile

"" Let coc.vim know where to find node
let g:coc_node_path = '~/.nvm/versions/node/v14.15.1/bin/node'
inoremap <silent><expr> <c-space> coc#refresh()
inoremap <silent><expr> <right> pumvisible() ? coc#_select_confirm() : "\<right>"

function! s:show_documentation()
  if (exists("g:coc_status") && coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call s:show_documentation()
