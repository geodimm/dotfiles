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
    sorting_strategy = 'ascending',
    layout_strategy = 'vertical',
    layout_config = {
      vertical = {
        prompt_position = 'top',
        mirror = true,
      },
    },
    wrap_results = true,
    file_sorter = sorters.get_fuzzy_file,
    file_ignore_patterns = {},
    generic_sorter = sorters.get_generic_fuzzy_sorter,
    winblend = 0,
    border = {},
    color_devicons = true,
    use_less = true,
    set_env = { ['COLORTERM'] = 'truecolor' },
    file_previewer = previewers.vim_buffer_cat.new,
    grep_previewer = previewers.vim_buffer_vimgrep.new,
    qflist_previewer = previewers.vim_buffer_qflist.new,
    dynamic_preview_title = true,
    mappings = {
      i = { ['<C-r>'] = trouble.open_with_trouble },
      n = { ['<C-r>'] = trouble.open_with_trouble },
    },
  },
  pickers = {
    lsp_references = {
      show_line = false,
    },
    lsp_incoming_calls = {
      show_line = false,
    },
    lsp_outgoing_calls = {
      show_line = false,
    },
    lsp_document_symbols = {
      show_line = false,
    },
    lsp_workspace_symbols = {
      show_line = false,
    },
    lsp_dynamic_workspace_symbols = {
      show_line = false,
    },
    diagnostics = {
      show_line = false,
    },
    lsp_definitions = {
      show_line = false,
    },
    lsp_type_definitions = {
      show_line = false,
    },
  },
  extensions = {
    lsp_handlers = {
      location = { telescope = { show_line = false } },
      symbol = { telescope = { show_line = false } },
      call_hierarchy = { telescope = { show_line = false } },
      code_action = { telescope = themes.get_dropdown({}) },
    },
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = 'smart_case',
    },
    menufacture = {
      mappings = {
        main_menu = { [{ 'i', 'n' }] = '<C-o>' },
      },
    },
  },
})

telescope.load_extension('fzf')
telescope.load_extension('lsp_handlers')
telescope.load_extension('refactoring')
telescope.load_extension('notify')
telescope.load_extension('menufacture')

local keymaps = require('user.keymaps')
keymaps.set('n', '<leader>ft', command.load_command, { desc = 'Open telescope' })
keymaps.set('n', '<leader>ff', telescope.extensions.menufacture.find_files, { desc = 'Files' })
keymaps.set('n', '<leader>fd', function()
  builtin.find_files({ search_dirs = { os.getenv('HOME') .. '/dotfiles' } })
end, { desc = 'dotfiles' })
keymaps.set('n', '<leader>f/', builtin.current_buffer_fuzzy_find, { desc = 'Current file' })
keymaps.set('n', '<leader>f*', telescope.extensions.menufacture.grep_string, { desc = 'Word under cursor' })
keymaps.set('n', '<leader>fb', function()
  builtin.buffers({ show_all_buffers = true, sort_lastused = true })
end, { desc = 'Buffers' })
keymaps.set('n', '<leader>fa', telescope.extensions.menufacture.live_grep, { desc = 'Fuzzy live grep' })
keymaps.set('n', '<leader>fm', builtin.keymaps, { desc = 'Keymapss' })
keymaps.set('n', '<leader>fgb', builtin.git_branches, { desc = 'Branches' })
keymaps.set('n', '<leader>fgc', builtin.git_commits, { desc = 'Commits' })
keymaps.set('n', '<leader>fgf', builtin.git_files, { desc = 'Files' })
keymaps.set('n', '<leader>fgh', builtin.git_bcommits, { desc = 'Buffer commits' })
keymaps.set('n', '<leader>fgs', builtin.git_status, { desc = 'Status' })

keymaps.register_group('<leader>f', 'Find', {})
keymaps.register_group('<leader>fg', 'Git', {})
