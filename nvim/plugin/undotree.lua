vim.g.undotree_SetFocusWhenToggle = 1

vim.api.nvim_set_keymap('n', '<leader>u', ':UndotreeToggle<CR>', { noremap = true })

require('which-key').register({ ['<leader>u'] = 'Open Undotree' })
