local nvim_tree, wk, status_ok
status_ok, nvim_tree = pcall(require, 'nvim-tree')
if not status_ok then
  return
end
status_ok, wk = pcall(require, 'which-key')
if not status_ok then
  return
end

function table.removeKey(table, key)
  table[key] = nil
  return table
end

nvim_tree.setup({
  disable_netrw = false,
  hijack_netrw = false,
  open_on_setup = false,
  ignore_ft_on_setup = { 'startify' },
  open_on_tab = false,
  hijack_cursor = false,
  update_cwd = false,
  diagnostics = { enable = true, icons = table.removeKey(require('config.icons').lsp, 'other') },
  update_focused_file = { enable = false, update_cwd = false, ignore_list = {} },
  system_open = { cmd = nil, args = {} },
  respect_buf_cwd = true,
  renderer = {
    add_trailing = true,
    highlight_git = true,
  },
  view = {
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
})

local opts = { silent = true, noremap = true }
vim.keymap.set('n', '<leader>fe', ':NvimTreeToggle<CR>', opts)
vim.keymap.set('n', '<leader>fl', ':NvimTreeFindFile<CR>', opts)

wk.register({
  ['<leader>fl'] = { 'Locate file in explorer' },
  ['<leader>fe'] = { 'Open file explorer' },
})
