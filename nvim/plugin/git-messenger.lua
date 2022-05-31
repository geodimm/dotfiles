vim.g.git_messenger_include_diff = 'current'
vim.g.git_messenger_floating_win_opts = { border = 'rounded' }
vim.g.git_messenger_always_into_popup = true

require('utils.whichkey').register({ mappings = { ['<leader>gm'] = { 'Show git blame' } }, opts = {} })
