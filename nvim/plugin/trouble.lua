local status_ok, trouble = pcall(require, 'trouble')
if not status_ok then
  return
end

trouble.setup({
  signs = require('user.icons').lsp,
})

local keymaps = require('user.keymaps')
keymaps.set('n', '<leader>xx', '<cmd>Trouble<CR>', { desc = 'Open' })
keymaps.set('n', '<leader>xw', '<cmd>Trouble workspace_diagnostics<CR>', { desc = 'Workspace diagnostics' })
keymaps.set('n', '<leader>xd', '<cmd>Trouble document_diagnostics<CR>', { desc = 'Document diagnostics' })
keymaps.set('n', '<leader>xl', '<cmd>Trouble loclist<CR>', { desc = 'Loclist' })
keymaps.set('n', '<leader>xq', '<cmd>Trouble quickfix<CR>', { desc = 'Quickfix' })

keymaps.set('n', '<leader>gR', '<cmd>Trouble lsp_references<CR>', { desc = 'References (Trouble)' })

keymaps.register_group('<leader>x', 'Trouble', {})
