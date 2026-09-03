local M = {}

function M.setup()
  require('lint_actions').setup()
  require('lint_actions.integrations.golangci').attach()
  require('lint_actions.integrations.markdownlint').attach()
end

return M
