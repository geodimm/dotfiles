local M = {}

function M.setup()
  require('gopher').setup({
    commands = {
      go = 'go',
      gomodifytags = 'gomodifytags',
      gotests = 'gotests',
      impl = 'impl',
      iferr = 'iferr',
    },
  })

  require('markview').setup({
    headings = {
      heading_1 = { sign = '' },
      heading_2 = { sign = '' },
    },
    code_blocks = { sign = false },
  })

  require('cronex').setup({})

  vim.g.mkdp_filetypes = { 'markdown' }

  require('lazydev').setup()
end

return M
