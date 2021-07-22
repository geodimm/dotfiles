require('toggleterm').setup({
    size = function(term)
        if term.direction == "horizontal" then
            return vim.o.lines * 0.25
        elseif term.direction == "vertical" then
            return vim.o.columns * 0.3
        end
    end,
    open_mapping = [[<leader>tt]],
    insert_mappings = false,
    shade_terminals = false,
    persist_size = false,
    direction = 'float',
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {border = 'single', winblend = 10}
})

local Terminal = require('toggleterm.terminal').Terminal

local lazygit = Terminal:new({cmd = "lazygit", hidden = true})
function TT_lazygit_toggle() lazygit:toggle() end
vim.api.nvim_set_keymap("n", "<leader>tl", "<cmd>lua TT_lazygit_toggle()<CR>",
                        {noremap = true, silent = true})

require('which-key').register({
    ["<leader>t"] = {
        name = "+toggeterm",
        t = "Open terminal",
        l = "Open lazygit"
    }
})
