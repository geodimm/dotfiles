" Fix colors
set term=xterm-256color

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'tomasr/molokai'
Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-fugitive'
Plugin 'kien/ctrlp.vim'
Plugin 'Yggdroot/indentLine'
Plugin 'davidhalter/jedi-vim'
Plugin 'klen/python-mode'
Plugin 'ervandew/supertab'
Plugin 'scrooloose/nerdtree'

call vundle#end()            " required
filetype plugin indent on    " required

" Plugins settings
" Powerline setup for MacVim/ GVim
set laststatus=2
if has("gui_running")
   let s:uname = system("uname")
   if s:uname == "Linux\n"
       set guifont=Ubuntu\ Mono\ for\ Powerline\ 12
   endif
endif

" Supertab
let g:SuperTabDefaultCompletionType = "<c-n>"

" Pymode
let g:pymode_rope = 0
let g:pymode_folding = 0
let g:pymode_lint_unmodified = 1
let g:pymode_lint_checkers = ['pep8', 'pyflakes']

" CtrlP Settings
let g:ctrlp_max_height = 30
set wildignore+=*.pyc,*_build/*,*/coverage/*
 
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal

" Personal settings

syntax enable
autocmd! bufwritepost ~/.vimrc source % " Autoupdate changes
colors molokai " Color scheme
set splitbelow " New files open on the right
set splitright " New files open on the bottom
set tabstop=4
set shiftwidth=4
set expandtab
set nu " Line numbers
map <F2> :NERDTreeToggle<CR>
nmap <C-S> :w<CR>
vmap <C-S> <Esc><C-S>gv
imap <C-S> <Esc><C-S>gi
nnoremap <C-J> <C-W><Down>
nnoremap <C-K> <C-W><Up>
nnoremap <C-L> <C-W><Right>
nnoremap <C-H> <C-W><Left>

" Old habits never die
nnoremap <Up> <NOP>
nnoremap <Down> <NOP>
nnoremap <Left> <NOP>
nnoremap <Right> <NOP>
inoremap <Up> <NOP>
inoremap <Down> <NOP>
inoremap <Left> <NOP>
inoremap <Right> <NOP>
