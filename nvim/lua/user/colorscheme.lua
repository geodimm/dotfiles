local name = 'catppuccin'

local function setup_tokyonight()
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
end

local function setup_catppuccin()
  local status_ok, catppuccin = pcall(require, 'catppuccin')
  if not status_ok then
    return
  end

  local cp = require('catppuccin.palettes').get_palette()

  local config = {
    flavour = 'macchiato',
    transparent_background = true,
    integrations = {
      nvimtree = true,
      navic = {
        enabled = true,
        custom_bg = cp.bg,
      },
      mason = true,
      notify = true,
      which_key = true,
    },
  }

  catppuccin.setup(config)
end

local setup = function()
  vim.opt.background = 'dark'
  if name == 'tokyonight' then
    setup_tokyonight()
  elseif name == 'catppuccin' then
    setup_catppuccin()
  end
  ---@diagnostic disable-next-line: param-type-mismatch
  pcall(vim.cmd, 'colorscheme ' .. name)
end

M.name = name
M.setup = setup

return M
