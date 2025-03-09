return {
  { 'nvim-tree/nvim-web-devicons' },
  {
    'norcalli/nvim-colorizer.lua',
    cmd = 'ColorizerToggle',
    opts = {},
  },
  {
    'folke/noice.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
    },
    opts = {
      lsp = {
        progress = {
          enabled = false,
        },
        hover = {
          enabled = true,
        },
        signature = {
          enabled = true,
        },
        message = {
          enabled = true,
        },
        override = {
          -- override the default lsp markdown formatter with Noice
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          -- override the lsp markdown formatter with Noice
          ['vim.lsp.util.stylize_markdown'] = true,
        },
      },
      presets = {
        bottom_search = false, -- use a classic bottom cmdline for search
        command_palette = false, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
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
    },
  },
  {
    'folke/snacks.nvim',
    lazy = false,
    priority = 1000,
    init = function()
      vim.b.miniindentscope_disable = true
    end,
    config = function()
      local icons = require('user.icons')
      local opts = {
        bigfile = {
          enabled = true,
        },
        dashboard = {
          sections = {
            { section = 'header' },
            { section = 'keys', icon = icons.ui.keyboard, indent = 2, padding = 1 },
            {
              section = 'recent_files',
              title = 'Recent Project Files',
              icon = icons.ui.history,
              file = vim.fn.fnamemodify('.', ':~'),
              limit = 5,
              cwd = true,
              indent = 2,
              padding = 1,
            },
            {
              section = 'recent_files',
              title = 'Recent Files',
              icon = icons.ui.history,
              file = vim.fn.fnamemodify('.', ':~'),
              limit = 5,
              cwd = vim.g.user_repos_dir or vim.fn.expand('$HOME/repos'),
              indent = 2,
              padding = 1,
            },
            {
              section = 'projects',
              title = 'Projects',
              icon = icons.file.directory_open,
              limit = 5,
              indent = 2,
              padding = 1,
            },
            { section = 'startup', icon = icons.ui.plug .. ' ' },
          },
        },
        gitbrowse = {
          enabled = true,
        },
        image = {
          enabled = true,
        },
        input = {
          icon_pos = 'title',
        },
        styles = {
          input = {
            relative = 'cursor',
            row = -3,
            col = 0,
            wo = {
              winhighlight = 'SnacksInputTitle:Title,SnacksInputIcon:Title',
            },
          },
        },
      }

      local keymap = require('utils.keymap')
      keymap.set({ 'n', 'v' }, '<leader>hB', Snacks.gitbrowse.open, { desc = 'Open in browser' })
      keymap.set('n', '<leader>cR', Snacks.rename.rename_file, { desc = 'Rename File' })

      keymap.register_group('<leader>t', 'Toggle', {})

      Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map('<leader>tl')
      Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>tw')
      Snacks.toggle.diagnostics():map('<leader>td')
      Snacks.toggle.inlay_hints():map('<leader>th')

      local feat = require('utils.feat')
      local formattingToggle = Snacks.toggle.new({
        id = 'formatting',
        name = 'Formatting',
        get = function()
          return feat.Formatting:is_enabled(0)
        end,
        set = function(state)
          return feat.Formatting:set(0, state)
        end,
      }, opts)
      formattingToggle:map('<leader>tf')

      Snacks.setup(opts)
    end,
  },
  {
    'folke/which-key.nvim',
    config = function()
      local icons = require('user.icons')
      local opts = {
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
      }

      require('which-key').setup(opts)
    end,
  },
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    init = function()
      local keymap = require('utils.keymap')
      keymap.register_group('<leader>x', 'Trouble', {})
    end,
    keys = {
      { '<leader>xx', '<cmd>Trouble<CR>', desc = 'Open' },
      { '<leader>xw', '<cmd>Trouble diagnostics toggle<CR>', desc = 'Workspace diagnostics' },
      { '<leader>xd', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>', desc = 'Document diagnostics' },
      { '<leader>xl', '<cmd>Trouble loclist toggle<CR>', desc = 'Loclist' },
      { '<leader>xq', '<cmd>Trouble quickfix toggle<CR>', desc = 'Quickfix' },
      {
        '<leader>xR',
        '<cmd>Trouble lsp toggle focus=false win.position=bottom<CR>',
        desc = 'LSP Definitions / references',
      },
    },
    opts = {},
  },
  {
    'MagicDuck/grug-far.nvim',
    init = function()
      local keymap = require('utils.keymap')
      keymap.register_group('<leader>s', 'Search', { mode = { 'n', 'v' } })
    end,
    keys = {
      {
        '<leader>sr',
        function()
          require('grug-far').open()
        end,
        desc = 'Search in project',
      },
      {
        '<leader>sw',
        function()
          require('grug-far').open({ prefills = { search = vim.fn.expand('<cword>') } })
        end,
        desc = 'Search for word under cursor',
      },
      {
        '<leader>sw',
        function()
          require('grug-far').with_visual_selection()
        end,
        desc = 'Search for selection',
        mode = { 'v', 'x' },
      },
      {
        '<leader>sf',
        function()
          require('grug-far').open({ prefills = { paths = vim.fn.expand('%') } })
        end,
        desc = 'Search in current file',
      },
      {
        '<leader>sa',
        function()
          require('grug-far').open({ engine = 'astgrep' })
        end,
        desc = 'Search with ast-grep engine',
      },
    },
    opts = {
      startInInsertMode = false,
    },
  },
  {
    'echasnovski/mini.indentscope',
    opts = {
      draw = {
        delay = 0,
      },
    },
  },
  {
    'OXY2DEV/markview.nvim',
    lazy = false,

    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
  },
}
