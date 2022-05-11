local telescope, wk, status_ok
status_ok, telescope = pcall(require, 'telescope')
if not status_ok then
  return
end
status_ok, _ = pcall(require, 'trouble')
if not status_ok then
  return
end
status_ok, wk = pcall(require, 'which-key')
if not status_ok then
  return
end

local sorters = require('telescope.sorters')
local previewers = require('telescope.previewers')
local themes = require('telescope.themes')
local trouble = require('trouble.providers.telescope')

telescope.setup({
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--glob',
      '!vendor/*',
    },
    prompt_prefix = ' ',
    selection_caret = '❯ ',
    entry_prefix = '  ',
    initial_mode = 'insert',
    selection_strategy = 'reset',
    sorting_strategy = 'descending',
    layout_strategy = 'flex',
    layout_config = {
      horizontal = { mirror = false, preview_width = 0.4 },
      vertical = { mirror = true, preview_height = 0.4 },
    },
    file_sorter = sorters.get_fuzzy_file,
    file_ignore_patterns = {},
    generic_sorter = sorters.get_generic_fuzzy_sorter,
    winblend = 0,
    border = {},
    borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
    color_devicons = true,
    use_less = true,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = previewers.vim_buffer_cat.new,
    grep_previewer = previewers.vim_buffer_vimgrep.new,
    qflist_previewer = previewers.vim_buffer_qflist.new,
    dynamic_preview_title = true,
    mappings = {
      i = { ['<C-r>'] = trouble.open_with_trouble },
      n = { ['<C-r>'] = trouble.open_with_trouble },
    },

    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = previewers.buffer_previewer_maker,
  },
  extensions = {
    lsp_handlers = {
      location = { telescope = { path_display = { 'shorten' } } },
      symbol = { telescope = { path_display = { 'shorten' } } },
      call_hierarchy = { telescope = { path_display = { 'shorten' } } },
      code_action = { telescope = themes.get_dropdown({}) },
    },
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = 'smart_case',
    },
  },
})

telescope.load_extension('fzf')
telescope.load_extension('lsp_handlers')

local opts = { silent = true, noremap = true }
vim.keymap.set('n', '<leader>ft', ':Telescope<CR>', opts)
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, opts)
vim.keymap.set('n', '<leader>f/', require('telescope.builtin').current_buffer_fuzzy_find, opts)
vim.keymap.set('n', '<leader>f*', require('telescope.builtin').grep_string, opts)
vim.keymap.set('n', '<leader>fb', function()
  require('telescope.builtin').buffers({ show_all_buffers = true, sort_lastused = true })
end, opts)
vim.keymap.set('n', '<leader>fa', function()
  require('telescope.builtin').live_grep({ path_display = { 'shorten' } })
end, opts)
vim.keymap.set('n', '<leader>fm', require('telescope.builtin').keymaps, opts)
vim.keymap.set('n', '<leader>fgf', require('telescope.builtin').git_files, opts)
vim.keymap.set('n', '<leader>fgs', require('telescope.builtin').git_status, opts)
vim.keymap.set('n', '<leader>fgb', require('telescope.builtin').git_branches, opts)
vim.keymap.set('n', '<leader>fgh', require('telescope.builtin').git_bcommits, opts)
vim.keymap.set('n', '<leader>fgc', require('telescope.builtin').git_commits, opts)

wk.register({
  ['<leader>f'] = {
    ['*'] = 'Word under cursor',
    ['/'] = 'Current file',
    a = 'Fuzzy search',
    b = 'Buffers',
    f = 'Files',
    m = 'Keymaps',
    t = 'Open Telescope',
  },
  ['<leader>fg'] = {
    name = '+git',
    b = 'Branches',
    c = 'Commits',
    f = 'Files',
    h = 'Buffer commits',
    s = 'Status',
  },
})
