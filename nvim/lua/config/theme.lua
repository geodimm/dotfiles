local M = {}

local theme = 'tokyonight'

local setup = function()
  vim.opt.syntax = 'on'
  vim.api.nvim_create_augroup('customise_highlight_groups', { clear = true })
  vim.api.nvim_create_autocmd('ColorScheme', {
    group = 'customise_highlight_groups',
    pattern = '*',
    callback = function()
      vim.cmd(':highlight link trailingWhiteSpace SpecialChar')
    end,
  })
  vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufReadPost' }, {
    group = 'customise_highlight_groups',
    pattern = '*',
    callback = function()
      vim.cmd(':match trailingWhiteSpace /s+$/')
    end,
  })

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
  vim.g.tokyonight_dark_sidebar = false
  vim.g.tokyonight_dark_float = false
  vim.g.vscode_style = 'dark'
  vim.g.vscode_italic_comment = 1
  vim.g.vscode_disable_nvimtree_bg = true
  pcall(vim.cmd, 'colorscheme ' .. theme)
end

local get_color = function(group, attr)
  return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(group)), attr)
end

M.theme = theme
M.setup = setup
M.get_color = get_color
return M
