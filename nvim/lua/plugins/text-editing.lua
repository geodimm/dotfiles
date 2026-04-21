local M = {}

function M.setup()
  require('mini.ai').setup({
    n_lines = 500,
  })
  require('mini.surround').setup({
    highlight_duration = 1000,
  })
  require('mini.comment').setup({})
  require('mini.align').setup({})
end

return M
