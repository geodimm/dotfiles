local M = {}

function M.setup()
  local lint = require('lint')
  local linters = lint.linters

  vim.filetype.add({
    pattern = {
      ['.*/.github/workflows/.*y*ml'] = 'yaml.github',
    },
  })

  linters.markdownlint.args = vim.list_extend(linters.markdownlint.args, {
    '--config',
    vim.fn.expand('$HOME/dotfiles/markdownlint/markdownlint.yaml'),
  })

  lint.linters_by_ft = {
    go = { 'golangcilint' },
    dockerfile = { 'hadolint' },
    markdown = { 'markdownlint' },
    github = { 'actionlint' },
    zsh = { 'zsh' },
  }

  vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufEnter', 'BufWritePost' }, {
    group = vim.api.nvim_create_augroup('user_lint', {}),
    desc = 'run nvim-lint',
    pattern = '*',
    callback = function(args)
      local opts = {}

      -- run golangcilint from project root (where go.mod is)
      if vim.bo[args.buf].filetype == 'go' then
        opts.cwd = vim.fs.root(args.buf, 'go.mod')
      end

      lint.try_lint(nil, opts)
    end,
  })
end

return M
