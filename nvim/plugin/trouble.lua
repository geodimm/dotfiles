vim.api.nvim_set_keymap('n', '<leader>xx', '<cmd>Trouble<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<leader>xw', '<cmd>Trouble workspace_diagnostics<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<leader>xd', '<cmd>Trouble document_diagnostics<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<leader>xl', '<cmd>Trouble loclist<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<leader>xq', '<cmd>Trouble quickfix<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<leader>gR', '<cmd>Trouble lsp_references<CR>', { silent = true, noremap = true })

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
