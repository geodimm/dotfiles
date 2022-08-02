local status_ok, truezen
status_ok, truezen = pcall(require, 'true-zen')
if not status_ok then
  return
end

truezen.setup({
  modes = {
    ataraxis = {
      minimum_writing_area = {
        width = 100,
      },
    },
  },
})

local keymaps = require('user.keymaps')
keymaps.set('n', '<leader>vn', function()
  local first = 0
  local last = vim.api.nvim_buf_line_count(0)
  truezen.narrow(first, last)
end, { desc = 'Narrow' })
keymaps.set('v', '<leader>vn', function()
  local first = vim.fn.line('v')
  local last = vim.fn.line('.')
  truezen.narrow(first, last)
end, { desc = 'Narrow' })
keymaps.set('n', '<leader>vf', truezen.focus, { desc = 'Focus' })
keymaps.set('n', '<leader>vm', truezen.minimalist, { desc = 'Minimalist' })
keymaps.set('n', '<leader>va', truezen.ataraxis, { desc = 'Ataraxis' })

keymaps.register_group('<leader>v', 'View', {})
keymaps.register_group('<leader>v', 'View', { mode = 'v' })
