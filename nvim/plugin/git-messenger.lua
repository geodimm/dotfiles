vim.g.git_messenger_include_diff = 'current'
vim.g.git_messenger_floating_win_opts = { border = 'rounded' }
vim.g.git_messenger_always_into_popup = true
vim.g.git_messenger_no_default_mappings = true
vim.g.git_messenger_popup_content_margins = false

require('user.keymaps').set('n', '<leader>hh', '<cmd>GitMessenger<CR>', { desc = 'Show history' })
