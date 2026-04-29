local M = {}

function M.setup()
  local keymap = require('utils.keymap')
  keymap.set('n', '<leader>cc', function()
    require('codex').toggle()
  end, { desc = 'Toggle Codex popup' })

  require('codex').setup({
    keymaps = {
      toggle = nil,
      quit = '<C-q>',
    },
    border = 'rounded',
    model = nil,
    autoinstall = false,
    panel = false,
  })
end

return M
