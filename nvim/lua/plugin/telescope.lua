require('telescope').setup {
    defaults = {
        vimgrep_arguments = {
            'rg', '--color=never', '--no-heading', '--with-filename',
            '--line-number', '--column', '--smart-case', '--glob', '!vendor/*'
        },
        prompt_prefix = " ",
        selection_caret = "❯ ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "descending",
        layout_strategy = "flex",
        layout_config = {
            horizontal = {mirror = false, preview_width = 0.4},
            vertical = {mirror = true, preview_height = 0.4}
        },
        file_sorter = require'telescope.sorters'.get_fuzzy_file,
        file_ignore_patterns = {},
        generic_sorter = require'telescope.sorters'.get_generic_fuzzy_sorter,
        winblend = 0,
        border = {},
        borderchars = {'─', '│', '─', '│', '┌', '┐', '┘', '└'},
        color_devicons = true,
        use_less = true,
        path_display = {shorten_path = true},
        set_env = {['COLORTERM'] = 'truecolor'}, -- default = nil,
        file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
        grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
        qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

        -- Developer configurations: Not meant for general override
        buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
    },
    extensions = {
        lsp_handlers = {
            code_action = {
                telescope = require('telescope.themes').get_dropdown({})
            }
        }
    }
}

require('telescope').load_extension('fzy_native')
require('telescope').load_extension('lsp_handlers')

vim.api.nvim_set_keymap('n', '<leader>ff',
                        '<cmd>lua require("telescope.builtin").find_files()<CR>',
                        {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>f/',
                        '<cmd>lua require("telescope.builtin").current_buffer_fuzzy_find()<CR>',
                        {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>f*',
                        '<cmd>lua require("telescope.builtin").grep_string()<CR>',
                        {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fb',
                        '<cmd>lua require("telescope.builtin").buffers({show_all_buffers = true, sort_lastused = true})<CR>',
                        {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fa',
                        '<cmd>lua require("telescope.builtin").live_grep()<CR>',
                        {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fm',
                        '<cmd>lua require("telescope.builtin").keymaps()<CR>',
                        {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fgf',
                        '<cmd>lua require("telescope.builtin").git_files()<CR>',
                        {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fgs',
                        '<cmd>lua require("telescope.builtin").git_status()<CR>',
                        {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fgb',
                        '<cmd>lua require("telescope.builtin").git_branches()<CR>',
                        {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fgh',
                        '<cmd>lua require("telescope.builtin").git_bcommits()<CR>',
                        {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fgc',
                        '<cmd>lua require("telescope.builtin").git_commits()<CR>',
                        {noremap = true})
