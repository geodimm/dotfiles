return {
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function(plugin, opts)
      local fzf = require(plugin.name)
      local icons = require('user.icons')

      opts = {
        globals = {
          file_icon_padding = ' ',
        },
        winopts = {
          preview = {
            border = 'rounded',
            layout = 'vertical',
            vertical = 'down:50%',
          },
          treesitter = {
            enabled = true,
          },
        },
        fzf_opts = {
          ['--layout'] = false,
        },
        keymap = {
          actions = {
            files = {
              ['ctrl-q'] = 'select-all+accept',
            },
          },
          builtin = {
            ['ctrl-q'] = 'select-all+accept',
          },
          fzf = {
            ['ctrl-q'] = 'select-all+accept',
          },
        },
        files = {
          cwd_prompt = false,
          actions = {
            ['ctrl-h'] = { fzf.actions.toggle_hidden },
          },
        },
        git = {
          icons = {
            ['M'] = { icon = icons.git.status.modified, color = 'yellow' },
            ['D'] = { icon = icons.git.status.deleted, color = 'red' },
            ['A'] = { icon = icons.git.status.added, color = 'green' },
            ['R'] = { icon = icons.git.status.renamed, color = 'yellow' },
            ['C'] = { icon = icons.git.status.copied, color = 'yellow' },
            ['T'] = { icon = icons.git.status.filetype_changed, color = 'magenta' },
            ['?'] = { icon = icons.git.status.untracked, color = 'magenta' },
          },
        },
      }

      fzf.setup(opts)

      local keymap = require('utils.keymap')
      keymap.set('n', '<leader>ft', fzf.builtin, { desc = 'Find anything' })
      keymap.set('n', '<leader>ff', fzf.files, { desc = 'Files' })
      keymap.set('n', '<leader>fd', function()
        fzf.files({ cwd = os.getenv('HOME') .. '/dotfiles' })
      end, { desc = 'dotfiles' })
      keymap.set('n', '<leader>f/', function()
        fzf.lgrep_curbuf({ previewer = false })
      end, { desc = 'Current file' })
      keymap.set('n', '<leader>f*', fzf.grep_cword, { desc = 'Word under cursor' })
      keymap.set('v', '<leader>f*', fzf.grep_visual, { desc = 'Visual selection' })
      keymap.set('n', '<leader>fb', function()
        fzf.buffers({ sort_mru = true, sort_lastused = true })
      end, { desc = 'Buffers' })
      keymap.set('n', '<leader>fa', fzf.live_grep, { desc = 'Fuzzy live grep' })
      keymap.set('n', '<leader>fm', fzf.keymaps, { desc = 'Keymaps' })
      keymap.set('n', '<leader>fgb', fzf.git_branches, { desc = 'Branches' })
      keymap.set('n', '<leader>fgc', fzf.git_commits, { desc = 'Commits' })
      keymap.set('n', '<leader>fgf', fzf.git_files, { desc = 'Files' })
      keymap.set('n', '<leader>fgh', fzf.git_bcommits, { desc = 'Buffer commits' })
      keymap.set('n', '<leader>fgs', fzf.git_status, { desc = 'Status' })

      keymap.register_group('<leader>f', 'Find', {})
      keymap.register_group('<leader>fg', 'Git', {})
    end,
  },
}
