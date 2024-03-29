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
  grey = 'grey',
}

local function colors(colorscheme)
  if colorscheme:find('catppuccin', 1, true) == 1 then
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
      grey = cp.overlay2,
    }
  end

  return default
end

M.colors = colors

return M
