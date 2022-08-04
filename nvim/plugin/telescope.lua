local status_ok, telescope = pcall(require, 'telescope')
if not status_ok then
  return
end
status_ok, _ = pcall(require, 'trouble')
if not status_ok then
  return
end

local builtin = require('telescope.builtin')
local command = require('telescope.command')
local sorters = require('telescope.sorters')
local previewers = require('telescope.previewers')
local themes = require('telescope.themes')
local trouble = require('trouble.providers.telescope')

local icons = require('user.icons')
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
    prompt_prefix = icons.telescope.prompt_prefix,
    selection_caret = icons.telescope.selection_caret,
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
telescope.load_extension('refactoring')
telescope.load_extension('notify')

local keymaps = require('user.keymaps')
keymaps.set('n', '<leader>ft', command.load_command, { desc = 'Open telescope' })
keymaps.set('n', '<leader>ff', builtin.find_files, { desc = 'Files' })
keymaps.set('n', '<leader>fh', function()
  builtin.find_files({ hidden = true })
end, { desc = 'Hidden files' })
keymaps.set('n', '<leader>fd', function()
  builtin.find_files({ search_dirs = { os.getenv('HOME') .. '/dotfiles' } })
end, { desc = 'Hidden files' })
keymaps.set('n', '<leader>fv', function()
  builtin.find_files({ search_dirs = { 'vendor/' } })
end, { desc = 'Go vendor/ files' })
keymaps.set('n', '<leader>f/', builtin.current_buffer_fuzzy_find, { desc = 'Current file' })
keymaps.set('n', '<leader>f*', builtin.grep_string, { desc = 'Word under cursor' })
keymaps.set('n', '<leader>fb', function()
  builtin.buffers({ show_all_buffers = true, sort_lastused = true })
end, { desc = 'Buffers' })
keymaps.set('n', '<leader>fa', function()
  builtin.live_grep({ path_display = { 'shorten' } })
end, { desc = 'Fuzzy live grep' })
keymaps.set('n', '<leader>fm', builtin.keymaps, { desc = 'Keymapss' })
keymaps.set('n', '<leader>fgb', builtin.git_branches, { desc = 'Branches' })
keymaps.set('n', '<leader>fgc', builtin.git_commits, { desc = 'Commits' })
keymaps.set('n', '<leader>fgf', builtin.git_files, { desc = 'Files' })
keymaps.set('n', '<leader>fgh', builtin.git_bcommits, { desc = 'Buffer commits' })
keymaps.set('n', '<leader>fgs', builtin.git_status, { desc = 'Status' })

keymaps.register_group('<leader>f', 'Find', {})
keymaps.register_group('<leader>fg', 'Git', {})
