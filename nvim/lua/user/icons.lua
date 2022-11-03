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

M.diff = {
  diff = '',
  added = '',
  ignored = '',
  modified = '',
  removed = '',
  renamed = '',
}

M.ui = {
  prompt = '❯',
  search = '',
  group = '',
  cog = '',
  cogs = '',
  lightbulb = '',
  lock = '',
  tree = '',
}

M.lspconfig = {
  Error = M.lsp.error,
  Hint = M.lsp.hint,
  Info = M.lsp.info,
  Other = M.lsp.other,
  Warn = M.lsp.warning,
}
M.telescope = {
  prompt_prefix = M.ui.search .. ' ',
  selection_caret = M.ui.prompt .. ' ',
}

return M
