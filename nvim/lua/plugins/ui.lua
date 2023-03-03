-- adopted from https://github.com/stevearc/dressing.nvim/blob/12b808a6867e8c38015488ad6cee4e3d58174182/lua/dressing/select/telescope.lua#L8
local function indexed_selection(opts, defaults, items)
  local entry_display = require('telescope.pickers.entry_display')
  local finders = require('telescope.finders')
  local displayer

  local function make_display(entry)
    local columns = {
      { entry.idx .. ':', 'TelescopePromptPrefix' },
      entry.text,
      { entry.kind, 'Comment' },
    }
    return displayer(columns)
  end

  local entries = {}
  local kind_width = 1
  local text_width = 1
  local idx_width = 1
  for idx, item in ipairs(items) do
    local text = opts.format_item(item)
    local kind = opts.kind

    kind_width = math.max(kind_width, vim.api.nvim_strwidth(kind))
    text_width = math.max(text_width, vim.api.nvim_strwidth(text))
    idx_width = math.max(idx_width, vim.api.nvim_strwidth(tostring(idx)))

    table.insert(entries, {
      idx = idx,
      display = make_display,
      text = text,
      kind = kind,
      ordinal = idx .. ' ' .. text .. ' ' .. kind,
      value = item,
    })
  end
  displayer = entry_display.create({
    separator = ' ',
    items = {
      { width = idx_width + 1 },
      { width = text_width },
      { width = kind_width },
    },
  })

  defaults.finder = finders.new_table({
    results = entries,
    entry_maker = function(item)
      return item
    end,
  })
end

return {
  { 'kyazdani42/nvim-web-devicons' },
  {
    'norcalli/nvim-colorizer.lua',
    init = function()
      vim.opt.termguicolors = true
    end,
    cmd = 'ColorizerToggle',
  },
  { 'goolord/alpha-nvim' },
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
    config = function(_, opts)
      local dressing = require('dressing')

      -- customise the telescope entry style for spellsuggest selections
      require('dressing.select.telescope').custom_kind['spellsuggest'] = indexed_selection

      dressing.setup(opts)
    end,
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
      local keymaps = require('user.keymaps')
      keymaps.register_group('<leader>x', 'Trouble', {})
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
      { '<leader>tt', '<cmd>ToggleTerm<CR>', desc = 'Open terminal' },
    },
    init = function()
      local keymaps = require('user.keymaps')
      keymaps.register_group('<leader>t', 'Terminal', {})
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
      local keymaps = require('user.keymaps')
      keymaps.register_group('<leader>s', 'Search', {})
      keymaps.register_group('<leader>s', 'Search', { mode = 'v' })
    end,
    keys = {
      {
        '<leader>sr',
        function()
          require('spectre').open()
        end,
        desc = 'Search in current file',
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
}
