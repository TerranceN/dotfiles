let mapleader =" "

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

call plug#end()

colorscheme wombat256mod
let g:airline_powerline_fonts = 1

set tabstop=2
set shiftwidth=2

set hidden

set nu
set rnu

set cursorline

highlight SignColumn guibg=#242424 ctermbg=234
highlight GitGutterAdd    guifg=#95e454 ctermfg=113
highlight GitGutterChange guifg=#bbbb00 ctermfg=3
highlight GitGutterDelete guifg=#e5786d ctermfg=173
set updatetime=100
:set signcolumn=yes
nnoremap <silent> <leader>d :GitGutterToggle<CR>
augroup GitGutter
   autocmd!
   autocmd BufReadPost *  GitGutterEnable
augroup END

augroup DetectIndent
   autocmd!
   autocmd BufReadPost *  DetectIndent
augroup END

nnoremap <silent> <leader>f :Files<CR>
nnoremap <silent> <leader>g :Rg<CR>
nnoremap <silent> <leader><leader> :
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader><Tab> :b#<CR>
nnoremap gp `[v`]

nnoremap <silent> <leader>u :UndotreeToggle<CR><C-w><left>
silent !mkdir ~/.vim/undodir > /dev/null 2>&1
set undodir=~/.vim/undodir
set undofile
