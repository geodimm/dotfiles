vim.g.git_messenger_include_diff = 'current'
vim.g.git_messenger_floating_win_opts = { border = 'rounded' }
vim.g.git_messenger_always_into_popup = true
vim.g.git_messenger_no_default_mappings = true
vim.g.git_messenger_popup_content_margins = false

vim.keymap.set('n', '<leader>hh', '<Plug>(git-messenger)', { noremap = true })
require('utils.whichkey').register({ mappings = { ['<leader>hh'] = { 'Show history' } }, opts = {} })
