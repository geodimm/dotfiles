local M = {}

local name = 'tokyonight'

local setup = function()
  vim.opt.background = 'dark'
  vim.g.tokyonight_dark_sidebar = false
  vim.g.tokyonight_dark_float = false
  vim.g.tokyonight_lualine_bold = true
  pcall(vim.cmd, 'colorscheme ' .. name)
end

M.name = name
M.setup = setup

return M
