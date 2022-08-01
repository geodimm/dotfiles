local status_ok, lightbulb = pcall(require, 'nvim-lightbulb')
if not status_ok then
  return
end

local icon = require('user.icons').lightbulb
vim.fn.sign_define('LightBulbSign', { text = icon, texthl = 'Character', linehl = '', numhl = '' })

lightbulb.setup({ autocmd = { enabled = true } })
