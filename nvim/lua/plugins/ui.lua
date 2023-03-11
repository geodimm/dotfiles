return {
  { 'kyazdani42/nvim-web-devicons' },
  {
    'norcalli/nvim-colorizer.lua',
    cmd = 'ColorizerToggle',
    config = true,
  },
  { 'goolord/alpha-nvim' },
  {
    'folke/noice.nvim',
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
          filter = {
            any = {
              { event = 'msg_show', kind = '', find = 'written' },
              { event = 'msg_show', kind = '', find = 'fewer lines' },
              { event = 'msg_show', kind = '', find = 'more line' },
              { event = 'msg_show', kind = '', find = 'more lines' },
              {
                cmdline = true,
              },
            },
          },
          opts = { skip = true },
        },
      },
    },
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
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
    'rcarriga/nvim-notify',
    opts = function()
      local icons = require('user.icons')
      return {
        timeout = 3000,
        stages = 'slide',
        icons = {
          DEBUG = icons.ui.bug,
          ERROR = icons.ui.times,
          INFO = icons.ui.info,
          TRACE = icons.ui.pencil,
          WARN = icons.ui.exclamation,
        },
      }
    end,
    config = function(_, opts)
      local notify = require('notify')
      vim.notify = notify
      notify.setup(opts)
    end,
  },
  {
    'folke/which-key.nvim',
    opts = function()
      local icons = require('user.icons')
      local key_labels = {
        ['<space>'] = icons.keyboard.Space,
        ['<cr>'] = icons.keyboard.Return,
        ['<bs>'] = icons.keyboard.Backspace,
        ['<tab>'] = icons.keyboard.Tab,
      }
      for k, v in pairs(key_labels) do
        key_labels[k:upper()] = v
      end

      return {
        icons = {
          group = icons.ui.list_ul .. ' ',
          breadcrumb = icons.ui.breadcrumb,
        },
        key_labels = key_labels,
        window = {
          border = 'rounded',
          margin = { 0, 0, 0, 0 },
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
      { '<leader>xw', '<cmd>Trouble workspace_diagnostics<CR>', desc = 'Workspace diagnostics' },
      { '<leader>xd', '<cmd>Trouble document_diagnostics<CR>', desc = 'Document diagnostics' },
      { '<leader>xl', '<cmd>Trouble loclist<CR>', desc = 'Loclist' },
      { '<leader>xq', '<cmd>Trouble quickfix<CR>', desc = 'Quickfix' },
      { '<leader>gR', '<cmd>Trouble lsp_references<CR>', desc = 'References (Trouble)' },
    },
    opts = {
      signs = require('user.icons').lsp,
    },
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
          guifg = vim.api.nvim_get_hl_by_name('FloatBorder', true).foreground,
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

      vim.api.nvim_create_augroup('user_toggleterm', { clear = true })
      vim.api.nvim_create_autocmd('TermOpen', {
        group = 'user_toggleterm',
        desc = 'configure toggleterm keymaps',
        pattern = 'term://*',
        callback = function()
          vim.keymap.set('t', '<leader>tt', '<cmd>wincmd q<CR>', { buffer = 0 })
        end,
      })

      toggleterm.setup(opts)
    end,
  },
  {
    'windwp/nvim-spectre',
    dependencies = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
    },
    init = function()
      local keymap = require('utils.keymap')
      keymap.register_group('<leader>s', 'Search', {})
      keymap.register_group('<leader>s', 'Search', { mode = 'v' })
    end,
    keys = {
      {
        '<leader>sr',
        function()
          require('spectre').open()
        end,
        desc = 'Search in project',
      },
      {
        '<leader>sw',
        function()
          require('spectre').open_visual({ select_word = true })
        end,
        desc = 'Search for word under cursor',
      },
      {
        '<leader>sw',
        function()
          require('spectre').open_visual()
        end,
        desc = 'Search for selection',
        mode = { 'v', 'x' },
      },
      {
        '<leader>sf',
        function()
          require('spectre').open_file_search()
        end,
        desc = 'Search in current file',
      },
    },
    opts = {
      mapping = {
        ['send_to_qf'] = {
          map = '<M-q>',
          cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
          desc = 'send all item to quickfix',
        },
      },
    },
  },
  {
    'giusgad/pets.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'edluffy/hologram.nvim',
    },
    cmd = 'PetsNew',
    opts = {
      popup = {
        avoid_statusline = true,
      },
    },
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
