local tree_cb = require'nvim-tree.config'.nvim_tree_callback
local lib = require "nvim-tree.lib"

function NvimTreeCloseParent() lib.parent_node(lib.get_node_at_cursor(), true) end

vim.g.nvim_tree_auto_close = 1
vim.g.nvim_tree_disable_netrw = 0
vim.g.nvim_tree_hijack_netrw = 0
vim.g.nvim_tree_update_cwd = 0
vim.g.nvim_tree_follow = 1
vim.g.nvim_tree_auto_ignore_ft = {'startify'}
vim.g.nvim_tree_width = 50
vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_lsp_diagnostics = 1
vim.g.nvim_tree_bindings = {
    {key = {"<CR>", "l", "o", "<2-LeftMouse>"}, cb = tree_cb("edit")},
    {key = "h", cb = ':lua NvimTreeCloseParent()<CR>'}
}

vim.api.nvim_set_keymap('n', '<leader>fe', ':NvimTreeToggle<CR>',
                        {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fl', ':NvimTreeFindFile<CR>',
                        {noremap = true})

require("which-key").register({
    ["<leader>fl"] = {"Locate file in explorer"},
    ["<leader>fe"] = {"Open file explorer"}
})
