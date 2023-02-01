local status_ok, treesj = pcall(require, 'treesj')
if not status_ok then
  return
end

treesj.setup({
  max_join_length = 2000,
  use_default_keymaps = false,
})

require('user.keymaps').set('n', '<leader>m', treesj.toggle, { desc = 'Split or Join code block with autodetect' })
