local status_ok, notify
status_ok, notify = pcall(require, 'notify')
if not status_ok then
  return
end

vim.notify = notify

local icons = require('user.icons')

notify.setup({
  timeout = 1500,
  stages = 'slide',
  icons = {
    DEBUG = icons.ui.bug,
    ERROR = icons.ui.times,
    INFO = icons.ui.info,
    TRACE = icons.ui.pencil,
    WARN = icons.ui.exclamation,
  },
})
