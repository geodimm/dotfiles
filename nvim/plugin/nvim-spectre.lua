local status_ok, spectre = pcall(require, 'spectre')
if not status_ok then
  return
end

spectre.setup({
  mapping = {
    ['send_to_qf'] = {
      map = '<M-q>',
      cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
      desc = 'send all item to quickfix',
    },
  },
})

local keymaps = require('user.keymaps')
keymaps.set('n', '<leader>sr', spectre.open, { desc = 'Search in current file' })
keymaps.set('n', '<leader>sw', function()
  spectre.open_visual({ select_word = true })
end, { desc = 'Search for selection' })
keymaps.set('v', '<leader>sw', spectre.open_visual, { desc = 'Search for word under cursor' })
keymaps.set('n', '<leader>sf', spectre.open_file_search, { desc = 'Search in current file' })

keymaps.register_group('<leader>s', 'Search', {})
keymaps.register_group('<leader>s', 'Search', { mode = 'v' })
