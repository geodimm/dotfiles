" vim: foldmethod=marker

" Define autocmd group vimrc.
augroup myvimrc
  autocmd!
augroup END
" Plugins {{{
call plug#begin('~/dotfiles/nvim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'srcery-colors/srcery-vim'
Plug 'arcticicestudio/nord-vim'
Plug 'ryanoasis/vim-devicons'
Plug 'mattn/calendar-vim'
Plug 'vimwiki/vimwiki'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tmux-plugins/vim-tmux'
Plug 'urbainvaes/vim-tmux-pilot'
Plug 'liuchengxu/vista.vim'
Plug 'wellle/targets.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'rhysd/git-messenger.vim'
Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
Plug 'fatih/vim-go', {'for': 'go', 'do': ':GoUpdateBinaries'}
Plug 'uiiaoo/java-syntax.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }

call plug#end()
" }}}
" General {{{
" Python
let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'

" Enable mouse
set mouse=a

" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=100

let mapleader = "\<Space>"

" Raise a dialogue for saving changes
set confirm

" Enable file type detection and plugin loading
filetype plugin indent on

" Use Unix as the standard file type
set ffs=unix,mac,dos

" Set filetype specific options via modelines
set modeline

" Don't select the first completion item; show even if there's only one match
set completeopt+=menuone

" Disable backups
set nobackup
set noswapfile
set nowritebackup

" Ignore these files
set wildignore+=*.pyc,*_build/*,*/coverage/*

" Colorscheme
set t_Co=256
if has("termguicolors")
    set t_8f=\[[38;2;%lu;%lu;%lum
    set t_8b=\[[48;2;%lu;%lu;%lum
    set termguicolors
endif
set background=dark
try
    colors nord
catch
endtry

" Enable syntax highlighing
syntax enable

" Don't show the current mode
set noshowmode

" Open splitpanes below and on the right of the current one.
set splitbelow
set splitright

" Toggle highlighting current line only in active splits
autocmd myvimrc VimEnter,WinEnter,BufWinEnter * setlocal cursorline
autocmd myvimrc WinLeave * setlocal nocursorline

" Set the colored vertical column
set colorcolumn=80

" Highlight current line
set cursorline

" Line numbers
set number

" Regex and search options
set magic

" First tab will complete to the longest common string
set wildmode=longest:full,full

" folds
set foldmethod=syntax
set foldlevelstart=99

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
" }}}
" Mappings {{{
" Save files
nnoremap <leader>w :w<CR>
vnoremap <leader>w <Esc>:w<CR>gv
" Save with sudo
cnoremap w!! %!sudo tee > /dev/null %

" Close files (will raise confirmation dialog for unsaved changes)
nnoremap <leader>q :q<CR>
vnoremap <leader>q <Esc>:q<CR>gv

" Temporary turn off hlsearch
nnoremap <silent> <leader><CR> :noh<CR>

" Toggle relative numbers
noremap <F4> :set relativenumber!<CR>
noremap! <F4> <Esc>:set relativenumber!<CR>gi

" Sort lines alphabetically
vnoremap <leader>s :sort<CR>

" Copy with Ctrl+C in visual mode
vnoremap <C-c> "+y<CR>

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

" Quickly edit dotfiles
nnoremap <silent> <leader>ev :vsplit $MYVIMRC<CR>
nnoremap <silent> <leader>et :vsplit ~/dotfiles/tmux/tmux.conf<CR>
nnoremap <silent> <leader>ed :vsplit ~/dotfiles/zsh/zshrc<CR>
nnoremap <silent> <leader>r :so $MYVIMRC<CR>

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
" }}}
" Abbreviations {{{
iab cdate <c-r>=strftime("%Y-%m-%d")<CR>
" }}}
" Plugins settings {{{
" vim-airline {{{
function! GetForm3Status()
    let total = str2nr($AWS_EXPIRY, 10) - strftime("%s")
    let mins = total / 60
    let secs = total % 60
    let duration = mins . "m" . secs . "s"
    if total < 0
        let duration = "EXPIRED"
    endif
    return "" . duration . "[" . $F3_ENVIRONMENT . "]"
endfunction

function! AirlineInit()
    call airline#parts#define_function('form3', 'GetForm3Status')
    call airline#parts#define_condition('form3', '$F3_ENVIRONMENT != "" && $AWS_EXPIRY != ""')
    let g:airline_section_y = airline#section#create_right(['form3', 'ffenc'])
endfunction
autocmd User AirlineAfterInit call AirlineInit()

let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='nord'
let g:airline_skip_empty_sections = 1
let g:airline_powerline_fonts = 1
" }}}
" vim-devicons {{{
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1
let g:webdevicons_enable_airline_statusline = 0
" }}}
" Pymode {{{
let g:pymode_python = 'python3'
let g:pymode_rope = 0
let g:pymode_lint_unmodified = 1
let g:pymode_lint_checkers = ['pyflakes', 'pep8', 'mccabe']
" C0111 - Missing docstrings
" W0703 - Cathing too general exception
let g:pymode_lint_ignore = [ "C0111", "W0703", ]
" }}}
" coc.nvim " {{{
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

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Highlight symbol under cursor on CursorHold
autocmd myvimrc CursorHold * silent call CocActionAsync('highlight')

" Use `[d` and `]d` to navigate diagnostics
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)

" gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> <leader>rn <Plug>(coc-rename)
nmap <silent> <leader>cf <Plug>(coc-fix-current)

" Use K to show documentation in preview window
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

nnoremap <silent> K :call <SID>show_documentation()<CR>

" }}}
" coc-explorer {{{
noremap <silent> <F2> :<C-u>CocCommand explorer --toggle<CR>
" }}}
" coc-git {{{
" navigate chunks of current buffer
nmap [c <Plug>(coc-git-prevchunk)
nmap ]c <Plug>(coc-git-nextchunk)

" show chunk diff at current position
nmap gm <Plug>(coc-git-chunkinfo)

" stage current chunk
nmap <silent> gs :<C-u>CocCommand git.chunkStage<CR>

" undo current chunk
nmap <silent> gu :<C-u>CocCommand git.chunkUndo<CR>

" create text object for git chunks
omap ig <Plug>(coc-git-chunk-inner)
xmap ig <Plug>(coc-git-chunk-inner)
omap ag <Plug>(coc-git-chunk-outer)
xmap ag <Plug>(coc-git-chunk-outer)

" Open the list of modified git files
nnoremap <silent> <space>g :<C-u>CocList --auto-preview gstatus<CR>
" }}}
" coc-terminal {{{

" Open/close the terminal buffer
nmap <silent> <leader>tt <Plug>(coc-terminal-toggle)

" }}}
" vim-go {{{
let g:go_def_mapping_enabled = 0
let g:go_auto_type_info = 1
let g:go_addtags_transform = "snakecase"
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_interfaces = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_variable_assignments = 1
let g:go_play_open_browser = 1
let g:go_dispatch_enabled = 1
let g:go_metalinter_autosave = 1
let g:go_doc_popup_window = 1
let g:go_term_mode = "split"
let g:go_term_enabled = 1
let g:go_term_close_on_exit = 0
let g:go_debug_windows = {'vars':'leftabove vnew','stack':'botright 10new'}

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
    let l:file = expand('%')
    if l:file =~# '^\f\+_test\.go$'
        call go#test#Test(0, 1)
    elseif l:file =~# '^\f\+\.go$'
        call go#cmd#Build(0)
    endif
endfunction

" run :GoDebugStart or :GoDebugTest based on the go file
function! s:debug_go_files()
    let l:file = expand('%')
    if l:file =~# '^\f\+_test\.go$'
        let test = search('func \(Test\|Example\)', "bcnW")
        if test == 0
            echo "vim-go: [debug] no test found immediate to cursor"
            return
        end

        let line = getline(test)
        let name = split(split(line, " ")[1], "(")[0]
        call go#debug#Start(1, "./...", "-test.run", name)
    elseif l:file =~# '^\f\+\.go$'
        call go#debug#Start(0)
    endif
endfunction

autocmd myvimrc FileType go nmap <buffer> <leader>gr <Plug>(go-run)
autocmd myvimrc FileType go nmap <buffer> <leader>gt <Plug>(go-test-func)
autocmd myvimrc FileType go nmap <buffer> <leader>gb :<C-u>call <SID>build_go_files()<CR>
autocmd myvimrc FileType go nmap <buffer> <leader>gc <Plug>(go-coverage-toggle)
autocmd myvimrc FileType go nmap <buffer> <leader>gd :<C-u>call <SID>debug_go_files()<CR>
autocmd myvimrc FileType go nmap <buffer> <leader>gi <Plug>(go-imports)
autocmd myvimrc FileType go nmap <buffer> <leader>b :<C-u>GoDebugBreakpoint<CR>
" }}}
" vista {{{
let g:vista_default_executive = 'coc'
let g:vista_finder_alternative_executives = []
let g:vista_fzf_preview = ['right:50%']
let g:vista_echo_cursor_strategy = 'floating_win'
let g:vista_disable_statusline = 0

noremap <F3> :<C-u>Vista!!<CR>
" }}}
" FZF settings {{{
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

" Mappings
nnoremap <leader>f :FZF<CR>
nnoremap <leader>s :FZFGGrep<CR>
nnoremap <leader>a :Ag<CR>
" }}}
" vimwiki {{{

" Show raw markup
let g:vimwiki_conceallevel = 0

" Disable temporary vimwkis
let g:vimwiki_global_ext = 0

" Disable table mappings to allow <Tab> autocompletion
let g:vimwiki_table_mappings = 0

" Configure auto-export to HTML for vimwiki files
let g:vimwiki_list = [{'path': '~/vimwiki/', 'auto_export': 1}]
hi VimwikiHeader1 guifg=#bf616a
hi VimwikiHeader2 guifg=#a3be8c
hi VimwikiHeader3 guifg=#ebcb8b
hi VimwikiHeader4 guifg=#88c0d0
hi VimwikiHeader5 guifg=#b48ead
hi VimwikiHeader6 guifg=#d8dee9
" }}}
" }}}
