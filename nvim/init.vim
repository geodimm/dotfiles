" vim: foldmethod=marker

" Define autocmd group vimrc.
augroup myvimrc
  autocmd!
augroup END
" Plugins {{{

call plug#begin('~/dotfiles/nvim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'psliwka/vim-smoothie'
Plug 'morhetz/gruvbox'
Plug 'ryanoasis/vim-devicons'
Plug 'camspiers/animate.vim'
Plug 'camspiers/lens.vim'
Plug 'mattn/calendar-vim'
Plug 'mbbill/undotree'
Plug 'vimwiki/vimwiki'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'antoinemadec/coc-fzf'
Plug 'tmux-plugins/vim-tmux'
Plug 'urbainvaes/vim-tmux-pilot'
Plug 'voldikss/vim-floaterm'
Plug 'liuchengxu/vista.vim'
Plug 'wellle/targets.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'rhysd/git-messenger.vim'
Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
Plug 'fatih/vim-go', {'for': ['go', 'gomod']}
Plug 'sebdah/vim-delve', {'for': 'go'}
Plug 'hashivim/vim-terraform'
Plug 'uiiaoo/java-syntax.vim'
Plug 'zinit-zsh/zinit-vim-syntax'
Plug 'towolf/vim-helm'
Plug 'mustache/vim-mustache-handlebars'
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

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Don't select the first completion item; show even if there's only one match
set completeopt+=menuone

" Disable backups
set nobackup
set noswapfile
set nowritebackup

" Enable persistent undo
set undofile

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
    let g:gruvbox_contrast_dark = "medium"
    let g:gruvbox_italic = 1
    colors gruvbox
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
noremap <F5> :set relativenumber!<CR>
noremap! <F5> <Esc>:set relativenumber!<CR>gi

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

" A quick way to move lines of text up or down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

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

" Easier navigation through split windows
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

" Functions {{{

function! s:show_current_filename() abort
    " Create a buffer and set the text
    let buf = nvim_create_buf(v:false, v:true)
    let fname = expand('%:p')
    call nvim_buf_set_lines(buf, 0, -1, v:true, ["", "     " . fname, ""])

    " Create the floating window
    let height = 3
    let width = len(fname) + 10
    let opts = {
                \ 'relative': 'editor',
                \ 'row': 2,
                \ 'col': float2nr((&columns - width) / 2),
                \ 'width': width,
                \ 'height': height,
                \ 'style': 'minimal'
                \ }

    " Create the content window
    let win_id = nvim_open_win(buf, v:true, opts)

    " Set the floating window highlighting
    call setwinvar(win_id, '&winhl', 'Normal:PMenuSel')

    " close easily with j, k or q
    noremap <buffer> <silent> j :<C-U>close<CR>
    noremap <buffer> <silent> k :<C-U>close<CR>
    noremap <buffer> <silent> q :<C-U>close<CR>
endfunction

noremap <silent> <leader>? :call <SID>show_current_filename()<CR>

"  }}}

" Plugins settings {{{

" undotree {{{

nnoremap <leader>u :UndotreeToggle<CR>
let g:undotree_SetFocusWhenToggle = 1

" }}}

" vim-airline {{{

let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#hunks#coc_git = 1
let g:airline_theme='gruvbox'
let g:airline_skip_empty_sections = 1
let g:airline_powerline_fonts = 1

let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.dirty='?'

" }}}

" vim-devicons {{{

let g:DevIconsEnableFoldersOpenClose = 1

" }}}

" lens.vim {{{

" Disable animate
let g:lens#animate = 0

" Resize width
let g:lens#width_resize_max = 120
let g:lens#width_resize_min = 10

" Disable lens for some windows
let g:lens#disabled_filetypes = ['coc-explorer', 'fzf']

" }}}

" animate.vim {{{

" Animation speed
let g:animate#duration = 300.0

" }}}

" vim-floaterm {{{

let g:floaterm_width = 0.90
let g:floaterm_height = 0.75
let g:floaterm_keymap_toggle = '<F3>'
let g:floaterm_position = 'center'
let g:floaterm_wintitle = v:false
let g:floaterm_borderchars = ['─', '│', '─', '│', '╭', '╮', '╯', '╰']

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
nmap <silent> <leader>gd <Plug>(coc-definition)
nmap <silent> <leader>gt <Plug>(coc-type-definition)
nmap <silent> <leader>gi <Plug>(coc-implementation)
nmap <silent> <leader>gr <Plug>(coc-references)
nmap <silent> <leader>cr <Plug>(coc-rename)
nmap <silent> <leader>cf <Plug>(coc-fix-current)

" Use K to show documentation in preview window
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocActionAsync('doHover')
  endif
endfunction

nnoremap <silent> K :call <SID>show_documentation()<CR>

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" }}}

" coc-fzf {{{

let g:coc_fzf_opts = ["--layout=reverse"]
let g:coc_fzf_preview = "right:50%"

nmap <silent> fcl :<C-u>CocFzfList<CR>
nmap <silent> fca :<C-u>CocFzfList actions<CR>
nmap <silent> fcc :<C-u>CocFzfList commands<CR>
nmap <silent> fcd :<C-u>CocFzfList diagnostics --current-buf<CR>

" }}}

" coc-explorer {{{

noremap <silent> <F2> :<C-u>CocCommand explorer --toggle<CR>

hi CocExplorerNormalFloatBorder guifg=#ebdbb2 guibg=#28282
hi CocExplorerNormalFloat guibg=#282828

" }}}

" coc-git {{{

" navigate chunks of current buffer
nmap [c <Plug>(coc-git-prevchunk)
nmap ]c <Plug>(coc-git-nextchunk)

" show chunk diff at current position
nmap <silent> <leader>gi <Plug>(coc-git-chunkinfo)

" stage current chunk
nmap <silent> <leader>gs :<C-u>CocCommand git.chunkStage<CR>

" undo current chunk
nmap <silent> <leader>gu :<C-u>CocCommand git.chunkUndo<CR>

" create text object for git chunks
omap ig <Plug>(coc-git-chunk-inner)
xmap ig <Plug>(coc-git-chunk-inner)
omap ag <Plug>(coc-git-chunk-outer)
xmap ag <Plug>(coc-git-chunk-outer)

" }}}

" vim-go {{{

let g:go_def_mapping_enabled = 0
let g:go_fmt_command = "goimports"
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
let g:go_metalinter_autosave = 0
let g:go_metalinter_autosave_enabled = []
let g:go_metalinter_enabled = []
let g:go_doc_keywordprg_enabled = 0
let g:go_term_mode = "split"
let g:go_rename_command = 'gopls'

" }}}

" vista {{{

let g:vista_default_executive = 'coc'
let g:vista_finder_alternative_executives = []
let g:vista_fzf_preview = ['right:50%']
let g:vista_echo_cursor_strategy = 'floating_win'

" Mappings
noremap <F4> :<C-u>Vista!!<CR>

" }}}

" fzf settings {{{

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
  \   'git grep --line-number '.shellescape(<q-args>) . ' -- ":!vendor/*"', 0,
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

command! -bang -nargs=* FZFRGrep
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case --follow --glob "!vendor/*" '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

let g:fzf_layout = { 'window': { 'width': 0.90, 'height': 0.75 } }

" Mappings
nnoremap <silent> ff     :<C-u>Files<CR>
nnoremap <silent> fgf    :<C-u>GFiles<CR>
nnoremap <silent> fgs    :<C-u>GFiles?<CR>
nnoremap <silent> fgc    :<C-u>BCommits<CR>
nnoremap <silent> f/     :<C-u>Lines<CR>
nnoremap <silent> f*     :<C-u>Lines <C-r>=expand('<cword>')<CR><CR>
nnoremap <silent> fb     :<C-u>Buffers<CR>
nnoremap <silent> fs     :<C-u>FZFGGrep<CR>
xnoremap <silent> fs     "sy:FZFGGrep <C-r>=substitute(substitute(@s, '\n', '', 'g'), '/', '\\/', 'g')<CR><CR>
nnoremap <silent> fa     :<C-u>FZFRGrep<CR>
nnoremap <silent> fv     :<C-u>Vista finder<CR>

" }}}

" vimwiki {{{

" Show raw markup
let g:vimwiki_conceallevel = 0

" Disable temporary vimwkis
let g:vimwiki_global_ext = 0

" Disable table mappings to allow <Tab> autocompletion
let g:vimwiki_table_mappings = 0

" Configure auto-export to HTML for vimwiki files
let g:vimwiki_list = [{'path': '~/vimwiki/', 'auto_export': 1, 'auto_toc': 1}]
hi VimwikiHeader1 guifg=#fb4934
hi VimwikiHeader2 guifg=#b8bb26
hi VimwikiHeader3 guifg=#fabd2f
hi VimwikiHeader4 guifg=#83a598
hi VimwikiHeader5 guifg=#d3869b
hi VimwikiHeader6 guifg=#8ec07c
" }}}

" }}}
