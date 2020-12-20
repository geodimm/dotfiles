syntax on

set t_Co=256
if has("termguicolors")
    set t_8f=\[[38;2;%lu;%lu;%lum
    set t_8b=\[[48;2;%lu;%lu;%lum
    set termguicolors
endif
set background=dark
try
    let g:onedark_terminal_italics = 1
    colors onedark
catch
endtry

" vim-devicons
let g:DevIconsEnableFoldersOpenClose = 1

" vim-airline
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#hunks#coc_git = 1
let g:airline_theme='onedark'
let g:airline_skip_empty_sections = 1
let g:airline_powerline_fonts = 1

let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.dirty='!'
