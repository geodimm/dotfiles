syntax on

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
    let g:onedark_terminal_italics = 1
    colors gruvbox
catch
endtry
