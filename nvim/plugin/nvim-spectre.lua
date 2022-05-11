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

local opts = { silent = true, noremap = true }
vim.keymap.set('n', '<leader>sr', spectre.open, opts)
vim.keymap.set('n', '<leader>sw', function()
  spectre.open_visual({ select_word = true })
end, opts)
vim.keymap.set('v', '<leader>sw', spectre.open_visual, opts)
vim.keymap.set('n', '<leader>sf', spectre.open_file_search, opts)

wk.register({
  ['<leader>s'] = {
    name = '+spectre',
    f = 'Search in current file',
    r = 'Search and replace',
    w = 'Search for word under cursor',
  },
})
wk.register({ ['<leader>s'] = { name = '+spectre', w = 'Search for selection' } }, { mode = 'v' })
