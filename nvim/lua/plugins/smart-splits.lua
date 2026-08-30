local M = {}

function M.setup()
  local keymap = require('utils.keymap')
  local smartsplits = require('smart-splits')
  keymap.set('n', '<A-h>', smartsplits.resize_left, { desc = 'Increase window width' })
  keymap.set('n', '<A-j>', smartsplits.resize_down, { desc = 'Increase window height' })
  keymap.set('n', '<A-k>', smartsplits.resize_up, { desc = 'Decrease window height' })
  keymap.set('n', '<A-l>', smartsplits.resize_right, { desc = 'Decrease window width' })

  keymap.set('n', '<C-\\>', smartsplits.move_cursor_previous, { desc = 'Switch to the last window' })

  local opts = {
    disable_multiplexer_nav_when_zoomed = false,
  }
  -- Upstream has no Ghostty backend; we ship lua/smart-splits/mux/ghostty.lua
  if vim.env.TERM_PROGRAM == 'ghostty' then
    local ghostty = require('smart-splits.mux.ghostty')
    local function move(direction)
      return function()
        ghostty.move(direction)
      end
    end
    -- Bypass smart-splits will_wrap: it AppleScripts as soon as winnr()
    -- thinks we are at an edge, skipping Neovim vsplits.
    keymap.set({ 'n', 'v', 't' }, '<C-h>', move('left'), { desc = 'Go to the left window' })
    keymap.set({ 'n', 'v', 't' }, '<C-j>', move('down'), { desc = 'Go to the down window' })
    keymap.set({ 'n', 'v', 't' }, '<C-k>', move('up'), { desc = 'Go to the up window' })
    keymap.set({ 'n', 'v', 't' }, '<C-l>', move('right'), { desc = 'Go to the right window' })
    -- Pass ctrl+hjkl through this surface; other panes keep goto_split.
    vim.api.nvim_create_autocmd({ 'VimEnter', 'VimResume' }, {
      group = vim.api.nvim_create_augroup('user_ghostty_nvim_keys', { clear = true }),
      desc = 'Ghostty: give Neovim ctrl+hjkl',
      callback = ghostty.claim_keys,
    })
    vim.api.nvim_create_autocmd({ 'VimLeave', 'VimSuspend' }, {
      group = vim.api.nvim_create_augroup('user_ghostty_nvim_keys_release', { clear = true }),
      desc = 'Ghostty: restore split-navigation ctrl+hjkl',
      callback = ghostty.release_keys,
    })
    ghostty.claim_keys()
    opts.multiplexer_integration = 'ghostty'
    opts.at_edge = 'stop'
  else
    keymap.set('n', '<C-h>', smartsplits.move_cursor_left, { desc = 'Go to the left window' })
    keymap.set('n', '<C-j>', smartsplits.move_cursor_down, { desc = 'Go to the down window' })
    keymap.set('n', '<C-k>', smartsplits.move_cursor_up, { desc = 'Go to the up window' })
    keymap.set('n', '<C-l>', smartsplits.move_cursor_right, { desc = 'Go to the right window' })
  end
  smartsplits.setup(opts)
end

return M
