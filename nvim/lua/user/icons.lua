local M = {}

M.os = {
  unix = '',
  dos = '',
  mac = '',
}

M.keyboard = {
  Alt = 'הּ',
  Backspace = '',
  Caps = 'בּ',
  Control = 'דּ',
  Return = '',
  Shift = 'וּ',
  Space = '',
  Tab = '',
}

M.lsp = {
  error = '',
  hint = '',
  info = '',
  other = ' ',
  warning = '',
}

M.file = {
  newfile = '',
  readonly = '',
  modified = 'ﱐ',
  unnamed = '',
  directory = '',
}

M.prompt = '❯'
M.search = ''
M.group = ''
M.cog = ''
M.lightbulb = ''
M.lock = ''
M.tree = ''
M.lspconfig = {
  Error = M.lsp.error,
  Hint = M.lsp.hint,
  Info = M.lsp.info,
  Other = M.lsp.other,
  Warn = M.lsp.warning,
}
M.telescope = {
  prompt_prefix = M.search .. ' ',
  selection_caret = M.prompt .. ' ',
}

return M
