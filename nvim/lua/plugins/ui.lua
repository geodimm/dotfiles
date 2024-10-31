return {
  { 'kyazdani42/nvim-web-devicons' },
  {
    'norcalli/nvim-colorizer.lua',
    cmd = 'ColorizerToggle',
    config = true,
  },
  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('alpha').setup(require('alpha.themes.startify').config)
    end,
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
          -- override cmp documentation with Noice (needs the other options to work)
          ['cmp.entry.get_documentation'] = true,
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
    'stevearc/dressing.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
    opts = {
      input = {
        win_options = {
          winblend = 0,
        },
        insert_only = false,
        prompt_align = 'center',
        relative = 'editor',
        prefer_width = 0.5,
      },
      select = {
        telescope = require('telescope.themes').get_cursor({
          layout_config = {
            width = function(_, max_columns, _)
              return math.min(max_columns, 80)
            end,
            height = function(_, _, max_lines)
              return math.min(max_lines, 15)
            end,
          },
        }),
      },
    },
  },
  {
    'folke/which-key.nvim',
    opts = function()
      local icons = require('user.icons')
      return {
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
    end,
  },
  {
    'folke/trouble.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
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
        '<leader>gR',
        '<cmd>Trouble lsp toggle focus=false win.position=bottom<CR>',
        desc = 'LSP Definitions / references',
      },
    },
    opts = {},
  },
  {
    'akinsho/nvim-toggleterm.lua',
    branch = 'main',
    keys = {
      { '<leader>tt', vim.cmd.ToggleTerm, desc = 'Open terminal' },
    },
    init = function()
      local keymap = require('utils.keymap')
      keymap.register_group('<leader>t', 'Terminal', {})
    end,
    opts = {
      size = function(term)
        if term.direction == 'horizontal' then
          return vim.o.lines * 0.25
        elseif term.direction == 'vertical' then
          return vim.o.columns * 0.3
        end
      end,
      highlights = {
        FloatBorder = {
          guifg = vim.api.nvim_get_hl(0, { name = 'FloatBorder' }).fg,
          guibg = '',
        },
      },
      open_mapping = nil, -- [[<leader>tt]],
      insert_mappings = false,
      shade_terminals = false,
      persist_size = false,
      direction = 'horizontal',
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = { border = 'curved', winblend = 0 },
    },
    config = function(_, opts)
      local toggleterm = require('toggleterm')

      vim.api.nvim_create_autocmd('TermOpen', {
        group = vim.api.nvim_create_augroup('user_toggleterm', { clear = true }),
        desc = 'configure toggleterm keymaps',
        pattern = 'term://*',
        callback = function()
          local keymap_opts = { buffer = 0 }
          vim.keymap.set('t', '<leader>tt', '<cmd>wincmd q<CR>', keymap_opts)
          vim.keymap.set('t', 'jj', [[<C-\><C-n>]], keymap_opts)
          vim.keymap.set('t', '<C-h>', [[<cmd>wincmd h<CR>]], keymap_opts)
          vim.keymap.set('t', '<C-j>', [[<cmd>wincmd j<CR>]], keymap_opts)
          vim.keymap.set('t', '<C-k>', [[<cmd>wincmd k<CR>]], keymap_opts)
          vim.keymap.set('t', '<C-l>', [[<cmd>wincmd l<CR>]], keymap_opts)
          vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], keymap_opts)
        end,
      })

      toggleterm.setup(opts)
    end,
  },
  {
    'MagicDuck/grug-far.nvim',
    init = function()
      local keymap = require('utils.keymap')
      keymap.register_group('<leader>s', 'Search', {})
      keymap.register_group('<leader>s', 'Search', { mode = 'v' })
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
    config = function(_, opts)
      require('grug-far').setup(opts)
    end,
  },
  {
    'echasnovski/mini.indentscope',
    opts = {
      draw = {
        delay = 0,
      },
    },
    config = function(_, opts)
      require('mini.indentscope').setup(opts)
    end,
  },
}
