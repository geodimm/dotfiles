local refactoring, wk, status_ok
status_ok, refactoring = pcall(require, 'refactoring')
if not status_ok then
  return
end
status_ok, wk = pcall(require, 'which-key')
if not status_ok then
  return
end

refactoring.setup({})

local opts = { noremap = true, silent = true, expr = false }
vim.keymap.set('v', '<leader>rr', refactoring.select_refactor, opts)
vim.keymap.set('v', '<leader>re', [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]], opts)
vim.keymap.set(
  'v',
  '<leader>rf',
  [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]],
  opts
)
vim.keymap.set('v', '<leader>rv', [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]], opts)
vim.keymap.set('v', '<leader>ri', [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]], opts)

vim.keymap.set('n', '<leader>rb', [[ <Cmd>lua require('refactoring').refactor('Extract Block')<CR>]], opts)
vim.keymap.set('n', '<leader>rbf', [[ <Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>]], opts)
vim.api.nvim_set_keymap(
  'n',
  '<leader>ri',
  [[ <Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
  { noremap = true, silent = true, expr = false }
)

wk.register({
  ['<leader>r'] = {
    name = '+refactoring',
    r = 'Select refactor',
    e = 'Extract Function',
    f = 'Extract Function To File',
    v = 'Extract Variable',
    i = 'Inline Variable',
  },
}, { mode = 'v' })
wk.register({
  ['<leader>r'] = {
    name = '+refactoring',
    b = 'Extract Block',
    bf = 'Extract Block To File',
    i = 'Inline Variable',
  },
}, { mode = 'n' })
