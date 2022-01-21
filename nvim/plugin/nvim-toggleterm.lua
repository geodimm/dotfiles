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
    float_opts = {border = 'single', winblend = 0}
})

function _G.set_terminal_keymaps()
    local opts = {noremap = true}
    vim.api
        .nvim_buf_set_keymap(0, 't', '<leader>tt', [[<C-\><C-n><C-W>l]], opts)
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

require('which-key').register({
    ["<leader>t"] = {name = "+toggleterm", t = "Open terminal"}
})
