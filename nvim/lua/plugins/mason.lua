local tools = {
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
  'vue_ls',
  'vtsls',
  'yaml-language-server',
  'actionlint',
  'golangci-lint',
  'google-java-format',
  'hadolint',
  'markdownlint',
  'gci',
  'goimports',
  'gofumpt',
  'latexindent',
  'shfmt',
  'stylua',
  'buildifier',
  'xmlformatter',
  'gomodifytags',
}

local M = {}

function M.setup()
  local icons = require('user.icons')
  require('mason').setup({
    ui = {
      border = 'rounded',
      icons = {
        package_installed = icons.ui.check,
        package_pending = icons.ui.play,
        package_uninstalled = icons.ui.times,
      },
    },
  })
  require('mason-tool-installer').setup({
    ensure_installed = tools,
    auto_update = true,
    run_on_start = true,
  })
end

return M
