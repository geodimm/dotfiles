local status_ok, treesitter_configs = pcall(require, 'nvim-treesitter.configs')
if not status_ok then
    return
end

treesitter_configs.setup({
  ensure_installed = {
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
    'python',
    'regex',
    'ruby',
    'rust',
    'scss',
    'toml',
    'vim',
    'yaml',
  },
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
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
  },
})
