local status_ok, installer = pcall(require, 'mason-tool-installer')
if not status_ok then
  return
end

local tools = {
  'actionlint',
  'bash-language-server',
  'deno',
  'dockerfile-language-server',
  'golangci-lint',
  'gopls',
  'hadolint',
  'html-lsp',
  'jdtls',
  'json-lsp',
  'jsonlint',
  'lua-language-server',
  'marksman',
  'markdownlint',
  'pyright',
  'shfmt',
  'stylua',
  'taplo',
  'terraform-ls',
  'yaml-language-server',
}

installer.setup({
  ensure_installed = tools,
  auto_update = false,
  run_on_start = false,
})
