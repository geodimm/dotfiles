local spectre, wk, status_ok
status_ok, spectre = pcall(require, 'spectre')
if not status_ok then
  return
end
status_ok, wk = pcall(require, 'which-key')
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

vim.api.nvim_set_keymap('n', '<leader>sr', '<cmd>lua require("spectre").open()<CR>', { noremap = true })
vim.api.nvim_set_keymap(
  'n',
  '<leader>sw',
  '<cmd>:lua require("spectre").open_visual({select_word=true})<CR>',
  { noremap = true }
)
vim.api.nvim_set_keymap('v', '<leader>sw', ':lua require("spectre").open_visual()<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>sf', '<cmd>:lua require("spectre").open_file_search()<CR>', { noremap = true })

wk.register({
  ['<leader>s'] = {
    name = '+spectre',
    f = 'Search in current file',
    r = 'Search and replace',
    w = 'Search for word under cursor',
  },
})
wk.register({ ['<leader>s'] = { name = '+spectre', w = 'Search for selection' } }, { mode = 'v' })
