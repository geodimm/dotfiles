local M = {}

local theme = 'tokyonight'

local setup = function()
  vim.opt.syntax = 'on'
  vim.api.nvim_create_augroup('customise_highlight_groups', { clear = true })
  vim.api.nvim_create_autocmd('ColorScheme', {
    group = 'customise_highlight_groups',
    pattern = '*',
    callback = function()
      vim.api.nvim_set_hl(0, 'PmenuThumb', { link = 'Visual' })
    end,
  })

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
