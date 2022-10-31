local M = {}

local name = 'catppuccin'

local setup_tokyonight = function()
  local status_ok, tokyonight = pcall(require, 'tokyonight')
  if not status_ok then
    return
  end

  tokyonight.setup({
    style = 'storm',
    transparent = false,
    styles = {
      sidebars = 'transparent',
      floats = 'transparent',
    },
    lualine_bold = true,
    on_colors = function(colors)
      -- revert https://github.com/folke/tokyonight.nvim/commit/7a13a0a40c0eb905c773560f7fba9cd6b17ee231
      colors.border_highlight = colors.blue0
    end,
  })
end

local setup_catppuccin = function()
  local status_ok, catppuccin = pcall(require, 'catppuccin')
  if not status_ok then
    return
  end

  catppuccin.setup({
    flavour = 'macchiato',
    integrations = {
      nvimtree = {
        transparent_panel = true,
      },
    },
  })
end

local setup = function()
  vim.opt.background = 'dark'
  if name == 'tokyonight' then
    setup_tokyonight()
  elseif name == 'catppuccin' then
    setup_catppuccin()
  end
  pcall(vim.cmd, 'colorscheme ' .. name)
end

M.name = name
M.setup = setup

return M
