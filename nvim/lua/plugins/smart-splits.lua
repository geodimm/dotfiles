local M = {}

function M.setup()
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

  require('smart-splits').setup({
    mux = {
      backend = 'smart-splits-backend-ghostty',
    },
    move = {
      at_edge = 'stop',
    },
  })
end

return M
