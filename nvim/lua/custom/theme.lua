vim.opt.syntax = "on"
vim.api.nvim_exec([[
augroup customise_highlight_groups
    autocmd!
    " Highlight trailing whitespaces
    autocmd ColorScheme * highlight link trailingWhiteSpace SpecialChar
    autocmd BufNewFile,BufReadPost * match trailingWhiteSpace /\s\+$/

    " Fix vim-floaterm border colours
    autocmd ColorScheme * highlight FloatermBorder guifg=none ctermfg=none

    " Override which-key background
    autocmd ColorScheme * highlight WhichKeyFloat guibg=1

    " Patch nvim-tree
    autocmd ColorScheme * highlight link NvimTreeGitDirty GitGutterChange

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
augroup end
]], false)

if vim.fn.has("termguicolors") == 1 then
    vim.go.t_8f = '[[38;2;%lu;%lu;%lum'
    vim.go.t_8b = '[[48;2;%lu;%lu;%lum'
    vim.opt.termguicolors = true
end

vim.opt.background = 'dark'
vim.g.onedark_terminal_italics = 1
vim.g.nord_bold = 1
vim.g.nord_italic = 1
vim.g.nord_italic_comments = 1
vim.g.nord_underline = 1
vim.g.nord_uniform_diff_background = 1
vim.g.gruvbox_italic = 1
vim.g.gruvbox_sign_column = 'bg0'
vim.cmd [[colorscheme onedark]]
