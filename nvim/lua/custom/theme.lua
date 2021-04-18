vim.o.syntax = "on"
vim.api.nvim_exec([[
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

    " Patch onedark
    autocmd ColorScheme onedark call onedark#set_highlight("DiffAdd", {"fg": onedark#GetColors().green})
    autocmd ColorScheme onedark call onedark#set_highlight("DiffChange", {"fg": onedark#GetColors().yellow})
    autocmd ColorScheme onedark call onedark#set_highlight("DiffDelete", {"fg": onedark#GetColors().red})
    autocmd ColorScheme onedark call onedark#set_highlight("Identifier", {"fg": onedark#GetColors().cyan})
    autocmd ColorScheme onedark call onedark#set_highlight("Keyword", {"fg": onedark#GetColors().purple})
    autocmd ColorScheme onedark call onedark#extend_highlight("Keyword", {"gui": "bold"})
    autocmd ColorScheme onedark call onedark#set_highlight("Constant", {"fg": onedark#GetColors().red})
    autocmd ColorScheme onedark call onedark#extend_highlight("Constant", {"gui": "italic"})

    autocmd ColorScheme onedark call onedark#set_highlight("goVarDefs", {"fg": onedark#GetColors().cyan})
    autocmd ColorScheme onedark call onedark#set_highlight("goVarAssign", {"fg": onedark#GetColors().cyan})

    autocmd ColorScheme onedark call onedark#set_highlight("CocHintSign", {"fg": onedark#GetColors().comment_grey})
    autocmd ColorScheme onedark call onedark#set_highlight("CocInfoSign", {"fg": onedark#GetColors().blue})
    autocmd ColorScheme onedark call onedark#set_highlight("CocWarningSign", {"fg": onedark#GetColors().yellow})
    autocmd ColorScheme onedark call onedark#set_highlight("CocErrorSign", {"fg": onedark#GetColors().red})
    autocmd ColorScheme onedark call onedark#set_highlight("CocHintHighlight", {"fg": onedark#GetColors().comment_grey})
    autocmd ColorScheme onedark call onedark#set_highlight("CocInfoHighlight", {"fg": onedark#GetColors().blue})
    autocmd ColorScheme onedark call onedark#set_highlight("CocWarningHighlight", {"fg": onedark#GetColors().yellow})
    autocmd ColorScheme onedark call onedark#set_highlight("CocErrorHighlight", {"fg": onedark#GetColors().red})

    " Reload the lualine theme
    autocmd ColorScheme * luafile ~/dotfiles/nvim/lua/plugin/lualine.lua
augroup end
]], false)

vim.o.t_Co = '256'
if vim.fn.has("termguicolors") == 1 then
    vim.o.t_8f = '[[38;2;%lu;%lu;%lum'
    vim.o.t_8b = '[[48;2;%lu;%lu;%lum'
    vim.o.termguicolors = true
end

vim.o.background = 'dark'
vim.g.onedark_terminal_italics = 1
vim.g.nord_bold = 1
vim.g.nord_italic = 1
vim.g.nord_italic_comments = 1
vim.g.nord_underline = 1
vim.g.nord_uniform_diff_background = 1
vim.g.gruvbox_italic = 1
vim.g.gruvbox_sign_column = 'bg0'
vim.cmd [[colorscheme onedark]]
