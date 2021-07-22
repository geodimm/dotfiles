local lsp_icons = require('config.icons').lsp

require('bufferline').setup({
    options = {
        diagnostics = 'nvim_lsp',
        max_name_length = 20,
        diagnostics_indicator = function(count, level)
            return " " .. lsp_icons[level] .. " " .. count
        end
    }
})

vim.api.nvim_set_keymap('n', '[b', ':BufferLineCyclePrev<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', ']b', ':BufferLineCycleNext<CR>',
                        {noremap = true, silent = true})

require('which-key').register({
    ["[b"] = {"Previous buffer"},
    ["]b"] = {"Next buffer"}
})
