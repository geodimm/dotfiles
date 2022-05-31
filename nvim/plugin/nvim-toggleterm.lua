local status_ok, toggleterm = pcall(require, 'toggleterm')
if not status_ok then
  return
end

toggleterm.setup({
  size = function(term)
    if term.direction == 'horizontal' then
      return vim.o.lines * 0.25
    elseif term.direction == 'vertical' then
      return vim.o.columns * 0.3
    end
  end,
  highlights = {
    FloatBorder = {
      guifg = require('config.theme').get_color('FloatBorder', 'fg#'),
      guibg = '',
    },
  },
  open_mapping = [[<leader>tt]],
  insert_mappings = false,
  shade_terminals = false,
  persist_size = false,
  direction = 'float',
  close_on_exit = true,
  shell = vim.o.shell,
  float_opts = { border = 'curved', winblend = 0 },
})

function _G.set_terminal_keymaps()
  local opts = { noremap = true, buffer = 0 }
  vim.keymap.set('t', '<leader>tt', [[<C-\><C-n><C-W>l]], opts)
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

require('utils.whichkey').register({
  mappings = {
    ['<leader>t'] = { name = '+toggleterm', t = 'Open terminal' },
  },
  opts = {},
})
