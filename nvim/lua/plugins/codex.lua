return {
  'johnseth97/codex.nvim',
  lazy = true,
  cmd = { 'Codex', 'CodexToggle' },
  keys = {
    {
      '<leader>cc',
      function()
        require('codex').toggle()
      end,
      desc = 'Toggle Codex popup',
    },
  },
  opts = {
    keymaps = {
      toggle = nil,
      quit = '<C-q>',
    },
    border = 'rounded',
    width = 0.33,
    height = 1,
    model = nil,
    autoinstall = false,
    panel = true,
  },
}
