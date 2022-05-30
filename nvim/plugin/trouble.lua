local opts = { silent = true, noremap = true }
vim.keymap.set('n', '<leader>xx', '<cmd>Trouble<CR>', opts)
vim.keymap.set('n', '<leader>xw', '<cmd>Trouble workspace_diagnostics<CR>', opts)
vim.keymap.set('n', '<leader>xd', '<cmd>Trouble document_diagnostics<CR>', opts)
vim.keymap.set('n', '<leader>xl', '<cmd>Trouble loclist<CR>', opts)
vim.keymap.set('n', '<leader>xq', '<cmd>Trouble quickfix<CR>', opts)
vim.keymap.set('n', '<leader>gR', '<cmd>Trouble lsp_references<CR>', opts)

local status_ok, trouble, wk
status_ok, trouble = pcall(require, 'trouble')
if not status_ok then
  return
end
status_ok, wk = pcall(require, 'which-key')
if not status_ok then
  return
end

trouble.setup({
  signs = require('config.icons').lsp,
})

wk.register({
  ['<leader>x'] = {
    name = '+trouble',
    x = 'Open',
    w = 'Workspace diagnostics',
    d = 'Document diagnostics',
    l = 'Loclist',
    q = 'Quickfix',
  },
  ['<leader>g'] = {
    R = 'References (Trouble)',
  },
})