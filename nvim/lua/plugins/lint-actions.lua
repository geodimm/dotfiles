local M = {}

function M.setup()
  require('lint_actions').setup({
    integrations = {
      nvim_lint = {
        golangci = true,
        markdownlint = true,
      },
    },
  })
  require('plugins.lint-actions.foldmarker').setup()
end

return M
