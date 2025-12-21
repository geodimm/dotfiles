return {
  {
    'mrjones2014/smart-splits.nvim',
    build = './kitty/install-kittens.bash',
    opts = {},
    config = function(_, opts)
      local keymap = require('utils.keymap')
      local smartsplits = require('smart-splits')
      keymap.set('n', '<A-h>', smartsplits.resize_left, { desc = 'Increase window width' })
      keymap.set('n', '<A-j>', smartsplits.resize_down, { desc = 'Increase window height' })
      keymap.set('n', '<A-k>', smartsplits.resize_up, { desc = 'Decrease window height' })
      keymap.set('n', '<A-l>', smartsplits.resize_right, { desc = 'Decrease window width' })

      keymap.set('n', '<C-h>', smartsplits.move_cursor_left, { desc = 'Go to the left window' })
      keymap.set('n', '<C-j>', smartsplits.move_cursor_down, { desc = 'Go to the down window' })
      keymap.set('n', '<C-k>', smartsplits.move_cursor_up, { desc = 'Go to the up window' })
      keymap.set('n', '<C-l>', smartsplits.move_cursor_right, { desc = 'Go to the right window' })
      keymap.set('n', '<C-\\>', smartsplits.move_cursor_previous, { desc = 'Switch to the last window' })

      -- keymap.set('n', '<leader><leader>h', smartsplits.swap_buf_left, { desc = 'Swap with left window' })
      -- keymap.set('n', '<leader><leader>j', smartsplits.swap_buf_down, { desc = 'Swap with down window' })
      -- keymap.set('n', '<leader><leader>k', smartsplits.swap_buf_up, { desc = 'Swap with up window' })
      -- keymap.set('n', '<leader><leader>l', smartsplits.swap_buf_right, { desc = 'Swap with right window' })
      smartsplits.setup(opts)
    end,
  },
  {
    'mikesmithgh/kitty-scrollback.nvim',
    enabled = true,
    lazy = true,
    cmd = {
      'KittyScrollbackGenerateKittens',
      'KittyScrollbackCheckHealth',
      'KittyScrollbackGenerateCommandLineEditing',
    },
    event = { 'User KittyScrollbackLaunch' },
    opts = {
      {
        restore_options = true,
        status_window = {
          show_timer = true,
          icons = {
            kitty = '󰄛',
            heart = '󰣐',
            nvim = '',
          },
        },
      },
    },
  },
}
