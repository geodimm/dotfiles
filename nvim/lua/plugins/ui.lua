local M = {}

function M.setup()
  local keymap = require('utils.keymap')
  local icons = require('user.icons')

  require('colorizer').setup({})

  require('noice').setup({
    lsp = {
      progress = {
        enabled = false,
      },
      hover = {
        enabled = false,
      },
      signature = {
        enabled = false,
      },
      message = {
        enabled = true,
      },
    },
    presets = {
      bottom_search = false,
      command_palette = false,
      long_message_to_split = true,
      inc_rename = false,
      lsp_doc_border = true,
    },
    routes = {
      {
        filter = { cmdline = 'Inspect' },
        view = 'split',
      },
    },
    views = {
      mini = {
        win_options = {
          winblend = 0,
        },
      },
    },
  })

  require('which-key').setup({
    icons = {
      group = icons.ui.list_ul .. ' ',
      breadcrumb = icons.ui.breadcrumb,
    },
    win = {
      col = 20,
      width = vim.fn.winwidth(0) - 40,
      border = 'rounded',
      padding = { 1, 1, 1, 1 },
    },
  })

  keymap.register_group('<leader>x', 'Trouble', { icon = '🚦' })
  require('trouble').setup({})

  keymap.register_group('<leader>s', 'Search', { mode = { 'n', 'v' } })
  require('grug-far').setup({
    startInInsertMode = false,
  })

  keymap.set('n', '<leader>xx', '<cmd>Trouble<CR>', { desc = 'Open' })
  keymap.set('n', '<leader>xw', '<cmd>Trouble diagnostics toggle<CR>', { desc = 'Workspace diagnostics' })
  keymap.set('n', '<leader>xd', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>', { desc = 'Document diagnostics' })
  keymap.set('n', '<leader>xl', '<cmd>Trouble loclist toggle<CR>', { desc = 'Loclist' })
  keymap.set('n', '<leader>xq', '<cmd>Trouble quickfix toggle<CR>', { desc = 'Quickfix' })
  keymap.set(
    'n',
    '<leader>xR',
    '<cmd>Trouble lsp toggle focus=false win.position=bottom<CR>',
    { desc = 'LSP Definitions / references' }
  )

  keymap.set('n', '<leader>sr', function()
    require('grug-far').open()
  end, { desc = 'Search in project' })
  keymap.set('n', '<leader>sw', function()
    require('grug-far').open({ prefills = { search = vim.fn.expand('<cword>') } })
  end, { desc = 'Search for word under cursor' })
  keymap.set({ 'v', 'x' }, '<leader>sw', function()
    require('grug-far').with_visual_selection()
  end, { desc = 'Search for selection' })
  keymap.set('n', '<leader>sf', function()
    require('grug-far').open({ prefills = { paths = vim.fn.expand('%') } })
  end, { desc = 'Search in current file' })
  keymap.set({ 'v', 'x' }, '<leader>sv', function()
    require('grug-far').open({ visualSelectionUsage = 'operate-within-range' })
  end, { desc = 'Search in visual selection' })
  keymap.set('n', '<leader>sa', function()
    require('grug-far').open({ engine = 'astgrep' })
  end, { desc = 'Search with ast-grep engine' })

  require('mini.indentscope').setup({
    draw = {
      delay = 0,
    },
  })
end

return M
