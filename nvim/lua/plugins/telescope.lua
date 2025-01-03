return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable('make') == 1
        end,
      },
      {
        'gbrlsnchs/telescope-lsp-handlers.nvim',
      },
    },
    config = function()
      local telescope = require('telescope')
      local builtin = require('telescope.builtin')
      local sorters = require('telescope.sorters')
      local previewers = require('telescope.previewers')
      local themes = require('telescope.themes')
      local trouble = require('trouble.sources.telescope')

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
            i = { ['<C-r>'] = trouble.open },
            n = { ['<C-r>'] = trouble.open },
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
        },
      })

      telescope.load_extension('refactoring')
      telescope.load_extension('noice')
      telescope.load_extension('fzf')
      telescope.load_extension('lsp_handlers')

      local keymap = require('utils.keymap')
      keymap.set('n', '<leader>ft', builtin.builtin, { desc = 'Open telescope' })
      keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Files' })
      keymap.set('n', '<leader>fd', function()
        builtin.find_files({ search_dirs = { os.getenv('HOME') .. '/dotfiles' } })
      end, { desc = 'dotfiles' })
      keymap.set('n', '<leader>f/', function()
        builtin.current_buffer_fuzzy_find(themes.get_dropdown({ previewer = false }))
      end, { desc = 'Current file' })
      keymap.set('n', '<leader>f*', builtin.grep_string, { desc = 'Word under cursor' })
      keymap.set('n', '<leader>fb', function()
        builtin.buffers({ show_all_buffers = true, sort_lastused = true })
      end, { desc = 'Buffers' })
      keymap.set('n', '<leader>fa', builtin.live_grep, { desc = 'Fuzzy live grep' })
      keymap.set('n', '<leader>fm', builtin.keymaps, { desc = 'Keymaps' })
      keymap.set('n', '<leader>fgb', builtin.git_branches, { desc = 'Branches' })
      keymap.set('n', '<leader>fgc', builtin.git_commits, { desc = 'Commits' })
      keymap.set('n', '<leader>fgf', builtin.git_files, { desc = 'Files' })
      keymap.set('n', '<leader>fgh', builtin.git_bcommits, { desc = 'Buffer commits' })
      keymap.set('n', '<leader>fgs', builtin.git_status, { desc = 'Status' })

      keymap.register_group('<leader>f', 'Find', {})
      keymap.register_group('<leader>fg', 'Git', {})
    end,
  },
}
