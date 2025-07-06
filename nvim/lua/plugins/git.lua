return {
  { 'tpope/vim-fugitive' },
  { 'sindrets/diffview.nvim' },
  {
    'lewis6991/gitsigns.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    init = function()
      local keymap = require('utils.keymap')

      keymap.register_group('<leader>h', 'Git', { mode = { 'n', 'v' } })
    end,
    config = function()
      local gitsigns = require('gitsigns')
      local icons = require('user.icons')

      local function blame_line()
        gitsigns.blame_line({ full = true })
      end
      local function next_hunk()
        if vim.wo.diff then
          vim.cmd.normal({ ']c', bang = true })
        else
          gitsigns.nav_hunk('next')
        end
      end
      local function prev_hunk()
        if vim.wo.diff then
          vim.cmd.normal({ '[c', bang = true })
        else
          gitsigns.nav_hunk('prev')
        end
      end

      local opts = {
        attach_to_untracked = true,
        diff_opts = {
          internal = false,
        },
        current_line_blame = true,
        current_line_blame_formatter = ' ' .. icons.git.compare .. ' <author>, <author_time:%Y-%m-%d> - <summary>',
        current_line_blame_opts = {
          virt_text_pos = 'right_align',
        },
        preview_config = {
          border = 'rounded',
        },
        sign_priority = 1000,
        on_attach = function()
          local keymap = require('utils.keymap')
          keymap.set('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'Stage buffer' })
          keymap.set('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'Reset buffer' })
          keymap.set('n', '<leader>hU', gitsigns.reset_buffer_index, { desc = 'Reset buffer index' })
          keymap.set('n', '<leader>hb', blame_line, { desc = 'Blame line' })
          keymap.set('n', '<leader>hc', gitsigns.show_commit, { desc = 'Show commit' })
          keymap.set('n', '<leader>hd', gitsigns.diffthis, { desc = 'Diff this' })
          keymap.set('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'Preview hunk in a floating window' })
          keymap.set('n', '<leader>ht', gitsigns.preview_hunk_inline, { desc = 'Preview hunk inline' })
          keymap.set({ 'n', 'v' }, '<leader>hr', gitsigns.reset_hunk, { desc = 'Reset hunk' })
          keymap.set({ 'n', 'v' }, '<leader>hs', gitsigns.stage_hunk, { desc = 'Stage/Unstage hunk' })
          keymap.set('n', ']c', next_hunk, { desc = 'Next hunk' })
          keymap.set('n', '[c', prev_hunk, { desc = 'Previous hunk' })
        end,
      }

      gitsigns.setup(opts)
    end,
  },
}
