vim.opt.syntax = "on"
vim.api.nvim_exec([[
augroup customise_highlight_groups
    autocmd!
    " Highlight trailing whitespaces
    autocmd ColorScheme * highlight link trailingWhiteSpace SpecialChar
    autocmd BufNewFile,BufReadPost * match trailingWhiteSpace /\s\+$/
augroup end
]], false)

vim.opt.termguicolors = true
vim.go.t_8f = '[[38;2;%lu;%lu;%lum'
vim.go.t_8b = '[[48;2;%lu;%lu;%lum'
vim.opt.background = 'dark'
vim.g.onedark_terminal_italics = 1
vim.g.nord_bold = 1
vim.g.nord_italic = 1
vim.g.nord_italic_comments = 1
vim.g.nord_underline = 1
vim.g.nord_uniform_diff_background = 1
vim.g.gruvbox_italic = 1
vim.g.gruvbox_sign_column = 'bg0'
vim.g.disable_toggle_style = 1
vim.g.onedark_style = 'dark'
vim.g.tokyonight_dark_sidebar = false
vim.g.tokyonight_dark_float = false
vim.g.vscode_style = 'dark'
vim.g.vscode_italic_comment = 1
vim.g.vscode_disable_nvimtree_bg = true
vim.cmd [[colorscheme tokyonight]]
