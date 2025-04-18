local icons = require('user.icons')

local tools = {
  -- language servers
  'bash-language-server',
  'clangd',
  'deno',
  'dockerfile-language-server',
  'harper-ls',
  'gopls',
  'helm-ls',
  'html-lsp',
  'json-lsp',
  'lua-language-server',
  'marksman',
  'pyright',
  'rust-analyzer',
  'taplo',
  'terraform-ls',
  'tilt',
  'yaml-language-server',

  -- linters
  'actionlint',
  'golangci-lint',
  'hadolint',
  'markdownlint',

  -- formatters
  'gci',
  'goimports',
  'gofumpt',
  'shfmt',
  'stylua',
  'buildifier',

  -- code actions
  'gomodifytags',
}

return {
  {
    'williamboman/mason.nvim',
    opts = {
      ui = {
        border = 'rounded',
        icons = {
          package_installed = icons.ui.check,
          package_pending = icons.ui.play,
          package_uninstalled = icons.ui.times,
        },
      },
    },
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    opts = {
      ensure_installed = tools,
      auto_update = true,
      run_on_start = true,
    },
  },
}
