local status_ok, null_ls = pcall(require, 'null-ls')
if not status_ok then
  return
end

null_ls.setup({
  debug = true,
  diagnostics_format = '#{m} (#{s})',
  on_attach = function(_, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  end,
  sources = {
    -- diagnostics
    null_ls.builtins.diagnostics.golangci_lint.with({
      extra_args = { '--config', vim.fn.expand('$HOME/dotfiles/golangci-lint/golangci.yml', nil, nil) },
    }),
    null_ls.builtins.diagnostics.hadolint,
    null_ls.builtins.diagnostics.jsonlint,
    null_ls.builtins.diagnostics.markdownlint.with({
      extra_args = {
        '--config',
        vim.fn.expand('$HOME/dotfiles/markdownlint/markdownlint.yaml', nil, nil),
      },
    }),
    null_ls.builtins.diagnostics.shellcheck,

    -- formatting
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.jq,
    null_ls.builtins.formatting.shfmt,
    null_ls.builtins.formatting.markdownlint,
    null_ls.builtins.formatting.markdownlint.with({
      extra_args = {
        '--config',
        vim.fn.expand('$HOME/dotfiles/markdownlint/markdownlint.yaml', nil, nil),
      },
    }),

    -- completion
    null_ls.builtins.completion.spell,
    null_ls.builtins.completion.luasnip,

    -- code actions
    null_ls.builtins.code_actions.refactoring,
    null_ls.builtins.code_actions.gitsigns,
    null_ls.builtins.code_actions.shellcheck,

    -- hover
    null_ls.builtins.hover.dictionary,
  },
})
