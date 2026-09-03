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
end

return M
