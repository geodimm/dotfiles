return {
  {
    'mfussenegger/nvim-lint',
    event = {
      'BufReadPre',
      'BufNewFile',
    },
    config = function()
      local lint = require('lint')
      local linters = require('lint').linters

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
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
