vim.g.nvim_tree_respect_buf_cwd = 1
vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_add_trailing = 1
vim.g.nvim_tree_icons = {
  default = '',
  symlink = '',
  git = {
    unstaged = '✗',
    staged = '✓',
    unmerged = '',
    renamed = '➜',
    untracked = '★',
    deleted = '',
  },
  folder = {
    arrow_open = '',
    arrow_closed = '',
    default = '',
    open = '',
    empty = '',
    empty_open = '',
    symlink = '',
    symlink_open = '',
  },
}

vim.api.nvim_set_keymap('n', '<leader>fe', ':NvimTreeToggle<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fl', ':NvimTreeFindFile<CR>', { noremap = true })

require('which-key').register({
  ['<leader>fl'] = { 'Locate file in explorer' },
  ['<leader>fe'] = { 'Open file explorer' },
})

require('nvim-tree').setup({
  disable_netrw = false,
  hijack_netrw = false,
  open_on_setup = false,
  ignore_ft_on_setup = { 'startify' },
  auto_close = true,
  open_on_tab = false,
  hijack_cursor = false,
  update_cwd = false,
  diagnostics = { enable = true, icons = require('config.icons').lsp },
  update_focused_file = { enable = false, update_cwd = false, ignore_list = {} },
  system_open = { cmd = nil, args = {} },
  view = {
    width = 40,
    side = 'left',
    auto_resize = false,
    mappings = {
      custom_only = false,
      list = {
        { key = { '<CR>', 'l', 'o', '<2-LeftMouse>' }, action = 'edit' },
        { key = 'h', action = 'close_node' },
      },
    },
  },
})
