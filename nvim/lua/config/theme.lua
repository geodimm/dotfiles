local M = {}

local theme = 'tokyonight'

local setup = function()
  vim.opt.syntax = 'on'
  vim.opt.termguicolors = true
  vim.go.t_8f = '[[38;2;%lu;%lu;%lum'
  vim.go.t_8b = '[[48;2;%lu;%lu;%lum'
  vim.opt.background = 'dark'
  vim.g.tokyonight_dark_sidebar = false
  vim.g.tokyonight_dark_float = false
  vim.g.tokyonight_lualine_bold = true
  pcall(vim.cmd, 'colorscheme ' .. theme)
end

M.theme = theme
M.setup = setup
return M
