local M = {}

function M.setup()
  local null_ls = require('null-ls')

  null_ls.setup({
    sources = {
      require('utils.golangci').code_action_source(),
    },
  })
end

return M
