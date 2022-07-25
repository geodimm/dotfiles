local status_ok, nvim_tree = pcall(require, 'nvim-tree')
if not status_ok then
  return
end

function table.removeKey(table, key)
  table[key] = nil
  return table
end

nvim_tree.setup({
  create_in_closed_folder = true,
  hijack_netrw = false,
  ignore_ft_on_setup = { 'startify' },
  diagnostics = { enable = true, icons = table.removeKey(require('config.icons').lsp, 'other') },
  respect_buf_cwd = true,
  renderer = {
    add_trailing = true,
    highlight_git = true,
    indent_markers = { enable = true },
    special_files = { 'Makefile', 'README.md', 'go.mod' },
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
})

local opts = { silent = true, noremap = true }
vim.keymap.set('n', '<leader>fe', ':NvimTreeToggle<CR>', opts)
vim.keymap.set('n', '<leader>fl', ':NvimTreeFindFile<CR>', opts)

require('utils.whichkey').register({
  mappings = {
    ['<leader>fl'] = { 'Locate file in explorer' },
    ['<leader>fe'] = { 'Open file explorer' },
  },
  opts = {},
})
