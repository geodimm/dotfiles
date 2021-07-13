vim.opt.syntax = "on"
vim.api.nvim_exec([[
augroup customise_highlight_groups
    autocmd!
    " Highlight trailing whitespaces
    autocmd ColorScheme * highlight link trailingWhiteSpace SpecialChar
    autocmd BufNewFile,BufReadPost * match trailingWhiteSpace /\s\+$/

    " Fix vim-floaterm border colours
    autocmd ColorScheme * highlight link FloatermBorder FloatBorder
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
vim.g.disable_toggle_style = 1
vim.g.onedark_style = 'dark'
vim.g.tokyonight_dark_sidebar = false
vim.g.tokyonight_dark_float = false
vim.cmd [[colorscheme tokyonight]]
