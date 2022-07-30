local status_ok, truezen, notify
status_ok, truezen = pcall(require, 'true-zen')
if not status_ok then
  return
end

status_ok, notify = pcall(require, 'notify')
if not status_ok then
  return
end

local open_callback = function(mode)
  local notify_opts = { title = 'true-zen', render = 'minimal', timeout = 200 }
  return function()
    notify(mode .. ' mode', vim.log.levels.INFO, notify_opts)
  end
end

truezen.setup({
  modes = {
    ataraxis = {
      open_callback = open_callback('Ataraxis'),
    },
    minimalist = {
      open_callback = open_callback('Minimalist'),
    },
    narrow = {
      open_callback = open_callback('Narrow'),
    },
    focus = {
      open_callback = open_callback('Focus'),
    },
  },
})

vim.keymap.set('n', '<leader>vn', function()
  local first = 0
  local last = vim.api.nvim_buf_line_count(0)
  truezen.narrow(first, last)
end, { noremap = true })
vim.keymap.set('v', '<leader>vn', function()
  local first = vim.fn.line('v')
  local last = vim.fn.line('.')
  truezen.narrow(first, last)
end, { noremap = true })
vim.keymap.set('n', '<leader>vf', truezen.focus, { noremap = true })
vim.keymap.set('n', '<leader>vm', truezen.minimalist, { noremap = true })
vim.keymap.set('n', '<leader>va', truezen.ataraxis, { noremap = true })

require('utils.whichkey').register({
  mappings = {
    ['<leader>v'] = {
      name = '+view',
      f = 'Focus',
      a = 'Ataraxis',
      n = 'Narrow',
      m = 'Minimalist',
    },
  },
  opts = {},
}, {
  mappings = {
    ['<leader>v'] = {
      name = '+view',
      n = 'Narrow',
    },
  },
  opts = { mode = 'v' },
})
