local M = {}

M.colors = {
  bg = 'none',
  fg = 'none',
  blue = 'blue',
  cyan = 'cyan',
  purple = 'purple',
  magenta = 'magenta',
  orange = 'orange',
  yellow = 'yellow',
  green = 'green',
  teal = 'teal',
  red = 'red',
}

local name = 'catppuccin'

local setup_tokyonight = function()
  local status_ok, tokyonight = pcall(require, 'tokyonight')
  if not status_ok then
    return
  end

  local config = {
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
  }

  tokyonight.setup(config)

  local tn = require('tokyonight.colors').setup(config)
  M.colors = {
    bg = tn.bg,
    fg = tn.fg,
    blue = tn.blue,
    cyan = tn.cyan,
    purple = tn.purple,
    magenta = tn.magenta,
    orange = tn.orange,
    yellow = tn.yellow,
    green = tn.green,
    teal = tn.teal,
    red = tn.red,
  }
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

  local cp = require('catppuccin.palettes').get_palette()
  M.colors = {
    bg = cp.mantle,
    fg = cp.text,
    blue = cp.blue,
    cyan = cp.sky,
    purple = cp.pink,
    magenta = cp.mauve,
    orange = cp.peach,
    yellow = cp.yellow,
    green = cp.green,
    teal = cp.teal,
    red = cp.red,
  }
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
