vim.api.nvim_set_keymap('n', '<leader>sr',
                        '<cmd>lua require("spectre").open()<CR>',
                        {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>sw',
                        'viw:lua require("spectre").open_visual()<CR>',
                        {noremap = true})
vim.api.nvim_set_keymap('v', '<leader>sw',
                        '<cmd>:lua require("spectre").open_visual()<CR>',
                        {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>sf',
                        '<cmd>:lua require("spectre").open_file_search()<CR>',
                        {noremap = true})

require('spectre').setup({
    mapping = {
        ['send_to_qf'] = {
            map = "<M-q>",
            cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
            desc = "send all item to quickfix"
        }
    }
})
