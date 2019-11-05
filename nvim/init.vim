" Define autocmd group vimrc.
augroup myvimrc
  autocmd!
augroup END

call plug#begin('~/dotfiles/nvim/plugged')

Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'urbainvaes/vim-tmux-pilot'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'srcery-colors/srcery-vim'
Plug 'liuchengxu/vista.vim'
Plug 'wellle/targets.vim'
Plug 'thaerkh/vim-indentguides'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'rhysd/git-messenger.vim'
Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
Plug 'airblade/vim-gitgutter'
Plug 'fatih/vim-go', {'for': 'go', 'do': ':GoUpdateBinaries'}
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }

call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Pymode
let g:pymode_python = 'python3'
let g:pymode_rope = 0
let g:pymode_folding = 0
let g:pymode_lint_unmodified = 1
let g:pymode_lint_checkers = ['pyflakes', 'pep8', 'mccabe']
" C0111 - Missing docstrings
" W0703 - Cathing too general exception
let g:pymode_lint_ignore = [ "C0111", "W0703", ]

" coc.vim
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Use `[e` and `]e` to navigate diagnostics
nmap <silent> [e <Plug>(coc-diagnostic-prev)
nmap <silent> ]e <Plug>(coc-diagnostic-next)

" Show all diagnostics
nnoremap <silent> <leader>d :<C-u>CocList diagnostics<cr>

" vim-go
let g:go_auto_type_info = 1
let g:go_addtags_transform = "snakecase"
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_interfaces = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1
let g:go_play_open_browser = 1
let g:go_dispatch_enabled = 1
let g:go_def_reuse_buffer = 0
let g:go_metalinter_autosave = 1
let g:go_doc_popup_window = 1

" NERDTree settings
noremap <F2> :NERDTreeToggle<CR>
let NERDTreeIgnore = ['\.pyc$', '\.egg-info$', '__pycache__']

" vim-devicons
let g:webdevicons_conceal_nerdtree_brackets = 1
let g:WebDevIconsNerdTreeBeforeGlyphPadding = ''
let g:WebDevIconsNerdTreeAfterGlyphPadding = ' '
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1
let g:airline_powerline_fonts = 1

" vista
let g:vista_default_executive = 'coc'
let g:vista_finder_alternative_executives = []
let g:vista_fzf_preview = ['right:50%']
let g:vista_echo_cursor_strategy = 'floating_win'
let g:vista_disable_statusline = 0
noremap <F3> :<C-u>Vista!!<CR>

" FZF settings
" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Command for git grep
" - fzf#vim#grep(command, with_column, [options], [fullscreen])
command! -bang -nargs=* FZFGGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number '.shellescape(<q-args>), 0,
  \   { 'dir': systemlist('git rev-parse --show-toplevel')[0] }, <bang>0)

" Colorizer
noremap <F6> :HexokinaseToggle<CR>
noremap! <F6> <Esc>:ColorToggle<CR>gi

" vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='srcery'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Python
let g:python_host_prog = '/usr/bin/python'
let g:python3_host_prog = '/usr/bin/python3'

" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

let mapleader = "\<Space>"
" Quickly edit dotfiles
nnoremap <silent> <leader>ev :vsplit $MYVIMRC<CR>
nnoremap <silent> <leader>et :vsplit ~/.tmux.conf<CR>
nnoremap <silent> <leader>ed :vsplit ~/.zshrc<CR>
nnoremap <silent> <leader>r :so $MYVIMRC<CR>

" FZF mappings
nnoremap <leader>f :FZF<CR>
nnoremap <leader>s :FZFGGrep<CR>
nnoremap <leader>c :Commits<CR>
nnoremap <leader>bc :BCommits<CR>

" Raise a dialogue for saving changes
set confirm

" Enable file type detection and plugin loading
filetype plugin indent on

" Use Unix as the standard file type
set ffs=unix,mac,dos

" Set filetype specific options via modelines
set modeline

" Don't open preview on autocompletion
set completeopt-=preview

" Don't select the first completion item; show even if there's only one match
set completeopt+=menuone

" Disable backups
set nobackup
set noswapfile
set nowritebackup

" Ignore these files
set wildignore+=*.pyc,*_build/*,*/coverage/*

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Colorscheme
set t_Co=256
if has("termguicolors")
    set t_8f=\[[38;2;%lu;%lu;%lum
    set t_8b=\[[48;2;%lu;%lu;%lum
    set termguicolors
endif
set background=dark
try
    colors srcery
catch
endtry

" Enable syntax highlighing
syntax enable

" Open splitpanes below and on the right of the current one.
set splitbelow
set splitright

" Toggle highlighting current line only in active splits
autocmd myvimrc VimEnter,WinEnter,BufWinEnter * setlocal cursorline
autocmd myvimrc WinLeave * setlocal nocursorline

" Set the colored vertical column
set colorcolumn=85

" Highlight current line
set cursorline

" Line numbers
set number
set relativenumber
noremap <F5> :set relativenumber!<CR>
noremap! <F5> <Esc>:set relativenumber!<CR>gi

" Regex and search options
set magic

" Temporary turn off hlsearch
nnoremap <silent> <leader><CR> :noh<CR>

" Save files
nnoremap <leader>w :w<CR>
vnoremap <leader>w <Esc>:w<CR>gv
" Save with sudo
cnoremap w!! %!sudo tee > /dev/null %

" Close files (will raise confirmation dialog for unsaved changes)
nnoremap <leader>q :q<CR>
vnoremap <leader>q <Esc>:q<CR>gv

" First tab will complete to the longest common string
set wildmode=longest:full,full

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text and formatting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Use 4 spaces instead of tabs
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" Use 2 spaces instead of tabs for HTML and YAML files
autocmd myvimrc FileType html,yaml setlocal shiftwidth=2 tabstop=2

" " Use 2 spaces instead of tabs for JS
autocmd myvimrc FileType javascript setlocal shiftwidth=2 tabstop=2 colorcolumn=80

" Wrap lines to 72 characters in git commit messages and use 2 spaces for tab
autocmd myvimrc FileType gitcommit setlocal spell textwidth=72 shiftwidth=2 tabstop=2 colorcolumn=+1 colorcolumn+=51

" Don't leave space between joined lines
set nojoinspaces

" Fix identation when pasting in Insert mode
set pastetoggle=<F4>

" Sort lines alphabetically
vnoremap <leader>s :sort<CR>

" Allow pasting the same selection multiple times
" 'p' to paste, 'gv' to re-select what was originally selected. 'y' to copy it again.
xnoremap p pgvy

" Go back to visual mode after reindenting
vnoremap < <gv
vnoremap > >gv

" Use double spacebar tab to select the current line
noremap <leader><leader> V

" Select the last inserted text
nnoremap <leader>le `[v`]

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Navigation and moving around
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Exit insert mode with jj
inoremap jj <Esc>

" Go to the next line in editor for wrapped lines
nnoremap j gj
nnoremap k gk

"Easier navigation through split windows
nnoremap <C-j> <C-w><Down>
nnoremap <C-k> <C-w><Up>
nnoremap <C-l> <C-w><Right>
nnoremap <C-h> <C-w><Left>

" We say 'NO' to arrow keys
nnoremap <Up> <NOP>
nnoremap <Down> <NOP>
nnoremap <Left> <NOP>
nnoremap <Right> <NOP>
inoremap <Up> <NOP>
inoremap <Down> <NOP>
inoremap <Left> <NOP>
inoremap <Right> <NOP>

" Useful mappings for managing tabs
noremap <leader>tn :tabnew<cr>
noremap <leader>to :tabonly<cr>
noremap <leader>tc :tabclose<cr>
noremap <leader>tm :tabmove

" Remap 0 to go to first non-blank character of the line
noremap 0 ^

" Remap Y to apply till EOL, just like D and C.
noremap Y y$

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Post-hooks
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Fix vim-devicons issues after reloading $MYVIMRC
if exists("g:loaded_webdevicons")
  call webdevicons#refresh()
endif
