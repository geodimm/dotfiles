local treesitter_parsers = {
  'bash',
  'css',
  'dockerfile',
  'go',
  'gomod',
  'gowork',
  'hcl',
  'help',
  'html',
  'http',
  'java',
  'javascript',
  'json',
  'json5',
  'jsonc',
  'lua',
  'make',
  'markdown',
  'markdown_inline',
  'python',
  'regex',
  'ruby',
  'rust',
  'scss',
  'toml',
  'vim',
  'yaml',
}

return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = treesitter_parsers,
      highlight = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = 'gnn',
          node_incremental = 'grn',
          scope_incremental = 'grc',
          node_decremental = 'grm',
        },
      },
      indent = { enable = true },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
            ['ap'] = '@parameter.outer',
            ['ip'] = '@parameter.inner',
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = { [']m'] = '@function.outer', [']]'] = '@class.outer' },
          goto_next_end = { [']M'] = '@function.outer', [']['] = '@class.outer' },
          goto_previous_start = { ['[m'] = '@function.outer', ['[['] = '@class.outer' },
          goto_previous_end = { ['[M'] = '@function.outer', ['[]'] = '@class.outer' },
        },
      },
    },
    config = function(_, opts)
      local treesitter_configs = require('nvim-treesitter.configs')
      treesitter_configs.setup(opts)
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },
  {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    keys = {
      {
        '<leader>m',
        function()
          require('treesj').toggle()
        end,
        desc = 'Split or Join code block with autodetect',
      },
    },
    opts = {
      max_join_length = 2000,
      use_default_keymaps = false,
    },
  },
  {
    'ThePrimeagen/refactoring.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
  },
}
