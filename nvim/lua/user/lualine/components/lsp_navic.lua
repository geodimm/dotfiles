local M = require('lualine.component'):extend()

local icons = require('user.icons')

local default_options = {
  navic_opts = {},
}

-- Initializer
M.init = function(self, options)
  M.super.init(self, options)

  self.options = vim.tbl_deep_extend('keep', self.options or {}, default_options)
end

M.update_status = function(self)
  local prefix = icons.ui.location .. ' '
  if not package.loaded['nvim-navic'] then
    return prefix
  end

  local data = require('nvim-navic').get_location(self.options.navic_opts)
  if data == '' then
    return prefix
  end

  return prefix .. data
end

return M
