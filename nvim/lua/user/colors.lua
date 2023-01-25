local M = {}

local default = {
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

local function colors(colorscheme)
  if colorscheme == 'tokyonight' then
    local status_ok, tokyonight = pcall(require, 'tokyonight.colors')
    if not status_ok then
      vim.notify('Failed to import tokyonight.colors', vim.log.levels.WARN)
      return default
    end

    local tn = tokyonight.setup()
    return {
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
  elseif colorscheme == 'catppuccin' then
    local status_ok, catppuccin = pcall(require, 'catppuccin.palettes')
    if not status_ok then
      vim.notify('Failed to import catppuccin.palettes', vim.log.levels.WARN)
      return default
    end

    local cp = catppuccin.get_palette()
    return {
      bg = cp.base,
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

  return default
end

M.colors = colors

return M
