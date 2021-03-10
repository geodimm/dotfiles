syntax on

augroup customise_highlight_groups
    autocmd!
    " Highlight trailing whitespaces
    autocmd ColorScheme * highlight link trailingWhiteSpace SpecialChar
    autocmd BufNewFile,BufReadPost * match trailingWhiteSpace /\s\+$/

    " Fix vim-floaterm border colours
    autocmd ColorScheme * highlight FloatermBorder guifg=none ctermfg=none

    " Disable special attributes for coc.nvim highlights
    autocmd ColorScheme * highlight CocHintHighlight gui=none cterm=none
    autocmd ColorScheme * highlight CocInfoHighlight gui=none cterm=none
    autocmd ColorScheme * highlight CocWarningHighlight gui=none cterm=none
    autocmd ColorScheme * highlight CocErrorHighlight gui=none cterm=none

    " Override coc-explorer border
    autocmd ColorScheme * highlight CocExplorerNormalFloatBorder guifg=8 guibg=1
    " Override coc-explorer background
    autocmd ColorScheme * highlight CocExplorerNormalFloat guibg=1
    " Override coc-explorer file tree git status highlights
    autocmd ColorScheme * highlight link CocExplorerGitPathChange GitGutterAdd
    autocmd ColorScheme * highlight link CocExplorerGitContentChange GitGutterChange
    autocmd ColorScheme * highlight link CocExplorerGitDeleted GitGutterDelete

    source ~/dotfiles/nvim/plugin/treesitter/nord.vim
    source ~/dotfiles/nvim/plugin/treesitter/onedark.vim
augroup end

set t_Co=256
if has("termguicolors")
    set t_8f=\[[38;2;%lu;%lu;%lum
    set t_8b=\[[48;2;%lu;%lu;%lum
    set termguicolors
endif
set background=dark
try
    let g:onedark_terminal_italics = 1
    let g:nord_bold = 1
    let g:nord_italic = 1
    let g:nord_italic_comments = 1
    let g:nord_underline = 1
    let g:nord_uniform_diff_background = 1
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
