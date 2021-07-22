vim.g.nvim_tree_auto_close = 0
vim.g.nvim_tree_disable_netrw = 0
vim.g.nvim_tree_hijack_netrw = 0
vim.g.nvim_tree_update_cwd = 0
vim.g.nvim_tree_follow = 1
vim.g.nvim_tree_auto_ignore_ft = {'startify'}
vim.g.nvim_tree_width = 40
vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_lsp_diagnostics = 1
vim.g.nvim_tree_special_files = {}
vim.g.nvim_tree_bindings = {
    {
        key = {"<CR>", "l", "o", "<2-LeftMouse>"},
        cb = ":lua require('nvim-tree').on_keypress('edit')<CR>"
    }, {
        key = "h",
        cb = ":lua lib = require('nvim-tree.lib');lib.parent_node(lib.get_node_at_cursor(), true)<CR>"
    }
}
vim.g.nvim_tree_icons = {
    default = '',
    symlink = '',
    git = {
        unstaged = "✗",
        staged = "✓",
        unmerged = "",
        renamed = "➜",
        untracked = "★",
        deleted = ""
    },
    folder = {
        arrow_open = "",
        arrow_closed = "",
        default = "",
        open = "",
        empty = "",
        empty_open = "",
        symlink = "",
        symlink_open = ""
    },
    lsp = require('config.icons').lsp
}

vim.api.nvim_set_keymap('n', '<leader>fe', ':NvimTreeToggle<CR>',
                        {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fl', ':NvimTreeFindFile<CR>',
                        {noremap = true})

require("which-key").register({
    ["<leader>fl"] = {"Locate file in explorer"},
    ["<leader>fe"] = {"Open file explorer"}
})
