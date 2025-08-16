local icons = require('user.icons')

local tools = {
  -- language servers
  'bash-language-server',
  'clangd',
  'dockerfile-language-server',
  'gopls',
  'helm-ls',
  'html-lsp',
  'jdtls',
  'json-lsp',
  'lua-language-server',
  'marksman',
  'pyright',
  'rust-analyzer',
  'taplo',
  'terraform-ls',
  'texlab',
  'tilt',
  'typescript-language-server',
  'yaml-language-server',

  -- linters
  'actionlint',
  'golangci-lint',
  'google-java-format',
  'hadolint',
  'markdownlint',

  -- formatters
  'gci',
  'goimports',
  'gofumpt',
  'latexindent',
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
