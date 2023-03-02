local status_ok, nvim_tree = pcall(require, 'nvim-tree')
if not status_ok then
  return
end

nvim_tree.setup({
  hijack_netrw = false,
  diagnostics = { enable = true, icons = require('user.icons').nerdtree },
  respect_buf_cwd = true,
  renderer = {
    add_trailing = true,
    highlight_git = true,
    indent_markers = { enable = true },
    special_files = { 'Makefile', 'README.md', 'go.mod' },
  },
  git = {
    ignore = false,
  },
  view = {
    adaptive_size = true,
    width = 40,
    side = 'left',
    mappings = {
      custom_only = false,
      list = {
        { key = { '<CR>', 'l', 'o', '<2-LeftMouse>' }, action = 'edit' },
        { key = 'h', action = 'close_node' },
      },
    },
  },
  actions = {
    file_popup = {
      open_win_config = {
        border = 'rounded',
      },
    },
  },
})

local keymaps = require('user.keymaps')
keymaps.set('n', '<leader>fl', function()
  local api = require('nvim-tree.api').tree
  api.open({ focus = true, find_file = true })
  api.reload()
end, { desc = 'Locate file in explorer' })
keymaps.set('n', '<leader>fe', nvim_tree.toggle, { desc = 'Open file explorer' })
