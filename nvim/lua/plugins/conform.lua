local M = {}

function M.setup()
  require('conform').setup({
    notify_on_error = true,
    format_on_save = function(_)
      if not vim.b.formatting then
        return
      end
      return {
        timeout_ms = 5000,
        lsp_format = 'fallback',
      }
    end,
    formatters_by_ft = {
      go = { 'gofumpt', 'goimports' },
      java = { 'google-java-format' },
      lua = { 'stylua' },
      markdown = { 'markdownlint' },
      rust = { 'rustfmt' },
      sh = { 'shfmt' },
      starlark = { 'buildifier' },
      latex = { 'latexindent' },
      xml = { 'xmlformatter' },
      javascript = { 'prettier' },
      javascriptreact = { 'prettier' },
      typescript = { 'prettier' },
      typescriptreact = { 'prettier' },
      vue = { 'prettier' },
      css = { 'prettier' },
      scss = { 'prettier' },
      html = { 'prettier' },
    },
    formatters = {
      markdownlint = {
        prepend_args = {
          '--config',
          vim.fn.expand('$HOME/dotfiles/markdownlint/markdownlint.yaml'),
        },
      },
    },
  })
end

return M
