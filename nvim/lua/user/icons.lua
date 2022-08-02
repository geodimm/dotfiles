local M = {}

local keyboard = {
  Alt = 'הּ',
  Backspace = '',
  Caps = 'בּ',
  Control = 'דּ',
  Return = '',
  Shift = 'וּ',
  Space = '',
  Tab = '',
}

local lsp = {
  error = '',
  hint = '',
  info = '',
  other = ' ',
  warning = '',
}

M.prompt = '❯'
M.search = ''
M.group = ''
M.lightbulb = ''
M.keyboard = keyboard
M.lsp = lsp
M.lspconfig = {
  Error = lsp.error,
  Hint = lsp.hint,
  Info = lsp.info,
  Other = lsp.other,
  Warn = lsp.warning,
}
M.telescope = {
  prompt_prefix = M.search .. ' ',
  selection_caret = M.prompt .. ' ',
}

return M
