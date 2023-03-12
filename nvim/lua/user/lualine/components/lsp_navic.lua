local M = require('lualine.component'):extend()

local default_options = {
  navic_opts = {},
}

-- Initializer
M.init = function(self, options)
  M.super.init(self, options)

  self.options = vim.tbl_deep_extend('keep', self.options or {}, default_options)
end

M.update_status = function(self)
  if not package.loaded['nvim-navic'] then
    return ''
  end

  return require('nvim-navic').get_location(self.options.navic_opts) or ''
end

return M
