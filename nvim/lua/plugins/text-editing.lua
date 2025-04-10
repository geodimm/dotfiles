local feat = require('utils.feat')

return {
  {
    'echasnovski/mini.ai',
    opts = {
      n_lines = 500,
    },
  },
  {
    'echasnovski/mini.surround',
    opts = {
      highlight_duration = 1000,
    },
  },
  {
    'echasnovski/mini.comment',
    opts = {},
  },
  {
    'echasnovski/mini.align',
    opts = {},
  },
  {
    'stevearc/conform.nvim',
    opts = {
      notify_on_error = true,
      format_on_save = function(bufnr)
        if not feat.Formatting:is_enabled(bufnr) then
          return
        end
        return {
          timeout_ms = 5000,
          lsp_format = 'fallback',
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        go = { 'gofumpt', 'goimports' },
        sh = { 'shfmt' },
        markdown = { 'markdownlint' },
        rust = { 'rustfmt' },
        starlark = { 'buildifier' },
      },
      formatters = {
        markdownlint = {
          prepend_args = {
            '--config',
            vim.fn.expand('$HOME/dotfiles/markdownlint/markdownlint.yaml'),
          },
        },
      },
    },
  },
}
