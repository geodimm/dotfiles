return {
  { 'tpope/vim-fugitive' },
  {
    'rhysd/git-messenger.vim',
    init = function()
      vim.g.git_messenger_include_diff = 'current'
      vim.g.git_messenger_floating_win_opts = { border = 'rounded' }
      vim.g.git_messenger_always_into_popup = true
      vim.g.git_messenger_no_default_mappings = true
      vim.g.git_messenger_popup_content_margins = false
    end,
    keys = {
      { '<leader>hh', vim.cmd.GitMessenger, desc = 'Show history' },
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    init = function()
      local keymap = require('utils.keymap')

      keymap.register_group('<leader>h', 'Git', {})
      keymap.register_group('<leader>h', 'Git', { mode = 'v' })
    end,
    config = function()
      local gitsigns = require('gitsigns')

      local function blame_line()
        gitsigns.blame_line({ full = true })
      end
      local function next_hunk()
        if vim.wo.diff then
          return ']c'
        end
        vim.schedule(gitsigns.next_hunk)
        return '<Ignore>'
      end
      local function prev_hunk()
        if vim.wo.diff then
          return '[c'
        end
        vim.schedule(gitsigns.prev_hunk)
        return '<Ignore>'
      end

      local icons = require('user.icons')

      gitsigns.setup({
        signs = {
          add = { text = '▌' },
          change = { text = '▌' },
          delete = { text = '▌' },
          topdelete = { text = '▌' },
          changedelete = { text = '▌' },
          untracked = { text = '▌' },
        },
        diff_opts = { internal = true },
        current_line_blame = true,
        current_line_blame_formatter = ' ' .. icons.git.compare .. ' <author>, <author_time:%Y-%m-%d> - <summary>',
        preview_config = {
          border = 'rounded',
        },
        on_attach = function()
          local keymap = require('utils.keymap')
          keymap.set('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'Stage buffer' })
          keymap.set('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'Reset buffer' })
          keymap.set('n', '<leader>hU', gitsigns.reset_buffer_index, { desc = 'Reset buffer index' })
          keymap.set('n', '<leader>hb', blame_line, { desc = 'Blame line' })
          keymap.set('n', '<leader>hd', gitsigns.diffthis, { desc = 'Diff this' })
          keymap.set('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'Preview hunk' })
          keymap.set({ 'n', 'v' }, '<leader>hr', gitsigns.reset_hunk, { desc = 'Reset hunk' })
          keymap.set({ 'n', 'v' }, '<leader>hs', gitsigns.stage_hunk, { desc = 'Stage hunk' })
          keymap.set('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'Undo stage hunk' })
          keymap.set('n', '<leader>ht', gitsigns.toggle_deleted, { desc = 'Toggle deleted' })
          keymap.set('n', ']c', next_hunk, { desc = 'Next hunk', expr = true })
          keymap.set('n', '[c', prev_hunk, { desc = 'Previous hunk', expr = true })
        end,
      })
    end,
  },
}
