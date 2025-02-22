return {
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local fzf = require('fzf-lua')
      local icons = require('user.icons')

      local opts = {
        winopts = {
          height = 0.95,
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
          ['--layout'] = 'reverse',
          ['--header-border'] = 'bottom',
        },
        files = {
          cwd_prompt = false,
          git_icons = true,
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

      local keymap = require('utils.keymap')
      keymap.set('n', '<leader>ft', fzf.builtin, { desc = 'Find anything' })
      keymap.set('n', '<leader>ff', fzf.files, { desc = 'Files' })
      keymap.set('n', '<leader>f/', function()
        fzf.lgrep_curbuf({ previewer = false })
      end, { desc = 'Current file' })
      keymap.set('n', '<leader>f*', fzf.grep_cword, { desc = 'Word under cursor' })
      keymap.set('v', '<leader>f*', fzf.grep_visual, { desc = 'Visual selection' })
      keymap.set('n', '<leader>fb', function()
        fzf.buffers({ sort_mru = true, sort_lastused = true })
      end, { desc = 'Buffers' })
      keymap.set('n', '<leader>fa', fzf.live_grep, { desc = 'Live grep' })
      keymap.set('n', '<leader>fm', fzf.marks, { desc = 'Marks' })
      keymap.set('n', '<leader>fk', fzf.keymaps, { desc = 'Keymaps' })
      keymap.set('n', '<leader>fgb', fzf.git_branches, { desc = 'Branches' })
      keymap.set('n', '<leader>fgc', fzf.git_commits, { desc = 'Commits' })
      keymap.set('n', '<leader>fgf', fzf.git_files, { desc = 'Files' })
      keymap.set('n', '<leader>fgh', fzf.git_bcommits, { desc = 'Buffer commits' })
      keymap.set('n', '<leader>fgs', fzf.git_status, { desc = 'Status' })

      keymap.register_group('<leader>f', 'Find', {})
      keymap.register_group('<leader>fg', 'Git', {})

      fzf.setup(opts)
    end,
  },
}
