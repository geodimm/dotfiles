local M = {}

local lsp_icons = {
  hint = '',
  info = '',
  warning = '',
  error = '',
  other = '',
}

M.lsp = lsp_icons
M.lspconfig = {
  Hint = lsp_icons.hint,
  Information = lsp_icons.info,
  Warning = lsp_icons.warning,
  Error = lsp_icons.error,
}

return M
