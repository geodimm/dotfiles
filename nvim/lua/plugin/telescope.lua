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
        prompt_title = '',
        results_title = '',
        preview_title = '',
        layout_config = {
            horizontal = {mirror = false},
            vertical = {mirror = true}
        },
        file_sorter = require'telescope.sorters'.get_fuzzy_file,
        file_ignore_patterns = {},
        generic_sorter = require'telescope.sorters'.get_generic_fuzzy_sorter,
        shorten_path = true,
        winblend = 0,
        border = {},
        borderchars = {'─', '│', '─', '│', '┌', '┐', '┘', '└'},
        color_devicons = true,
        use_less = true,
        set_env = {['COLORTERM'] = 'truecolor'}, -- default = nil,
        file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
        grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
        qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

        -- Developer configurations: Not meant for general override
        buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
    }
}

require('telescope').load_extension('fzy_native')

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
                        '<cmd>lua require("telescope.builtin").grep_string({word_match = "--word-regexp", only_sort_text = true, search = ""})<CR>',
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
