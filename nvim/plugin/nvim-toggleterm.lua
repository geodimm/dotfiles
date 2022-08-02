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
      guifg = vim.api.nvim_get_hl_by_name('FloatBorder', true).foreground,
      guibg = '',
    },
  },
  open_mapping = nil, -- [[<leader>tt]],
  insert_mappings = false,
  shade_terminals = false,
  persist_size = false,
  direction = 'float',
  close_on_exit = true,
  shell = vim.o.shell,
  float_opts = { border = 'curved', winblend = 0 },
})

vim.api.nvim_create_augroup('user_toggleterm', { clear = true })
vim.api.nvim_create_autocmd('TermOpen', {
  group = 'user_toggleterm',
  desc = 'configure toggleterm keymaps',
  pattern = 'term://*',
  callback = function()
    local opts = { buffer = 0 }
    vim.keymap.set('t', '<leader>tt', [[<C-\><C-n><C-W>l]], opts)
  end,
})

local keymaps = require('user.keymaps')
keymaps.set('n', '<leader>tt', '<cmd>ToggleTerm<CR>', { desc = 'Open terminal' })
keymaps.register_group('<leader>t', 'Terminal', {})
