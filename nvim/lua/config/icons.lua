local M = {}

local lsp = {
  error = '',
  hint = '',
  info = '',
  other = ' ',
  warning = '',
}

M.lightbulb = ''
M.lsp = lsp
M.lspconfig = {
  Error = lsp.error,
  Hint = lsp.hint,
  Info = lsp.info,
  Other = lsp.other,
  Warn = lsp.warning,
}

return M
