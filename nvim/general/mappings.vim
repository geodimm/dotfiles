let mapleader = "\<Space>"

" Save files
nnoremap <leader>w :w<CR>
vnoremap <leader>w <Esc>:w<CR>gv

" Quit vim
nnoremap <leader>q :q<CR>
vnoremap <leader>q <Esc>:q<CR>gv

" Save with sudo
cnoremap w!! %!sudo tee > /dev/null %

" Temporary turn off hlsearch
nnoremap <silent> <leader><CR> :noh<CR>

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
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Use double spacebar tab to select the current line
noremap <leader><leader> V

" Quickly edit dotfiles
nnoremap <silent> <leader>ev :vsplit $MYVIMRC<CR>
nnoremap <silent> <leader>et :vsplit ~/dotfiles/tmux/tmux.conf<CR>
nnoremap <silent> <leader>ez :vsplit ~/dotfiles/zsh/zshrc<CR>
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
nnoremap <C-f> :vertical wincmd f<CR>

" Use alt + hjkl to resize windows
nnoremap <silent> <M-j> :resize -2<CR>
nnoremap <silent> <M-k> :resize +2<CR>
nnoremap <silent> <M-h> :vertical resize -10<CR>
nnoremap <silent> <M-l> :vertical resize +10<CR>

" Useful mappings for managing tabs
noremap <leader>tn :tabnew<cr>
noremap <leader>to :tabonly<cr>
noremap <leader>tc :tabclose<cr>
noremap <leader>tm :tabmove

" Remap 0 to go to first non-blank character of the line
noremap 0 ^

" Remap Y to apply till EOL, just like D and C.
noremap Y y$

" Abbreviations
iab cdate <c-r>=strftime("%Y-%m-%d")<CR>
iab todo <c-r>='TODO (Georgi Dimitrov):'<CR>

" Formal XML
cnoremap fx %!python3 -c "import xml.dom.minidom, sys; print(xml.dom.minidom.parse(sys.stdin).toprettyxml())"
" Formal JSON
cnoremap fj %!python -m json.tool

" Close all buffers but the current one
command! BufOnly silent! execute "%bd|e#|bd#"
noremap <leader>b :BufOnly<CR>

" Print the sum of all numbers in the first column of the current buffer
cnoremap sum %r!awk '{sum+=$1} END {print "Total: "sum}' %
