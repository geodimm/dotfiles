local status_ok, navic = pcall(require, 'nvim-navic')
if not status_ok then
  return
end

local icons = require('user.icons')

navic.setup({
  highlight = true,
  separator = ' ' .. icons.ui.breadcrumb .. ' ',
})
