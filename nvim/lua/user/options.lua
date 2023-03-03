-- vim: foldmethod=marker
-- Message output on vim actions {{{1
vim.opt.shortmess = {
  t = true, -- truncate file messages at start
  A = true, -- ignore annoying swap file messages
  o = true, -- file-read message overwrites previous
  O = true, -- file-read message overwrites previous
  T = true, -- truncate non-file messages in middle
  f = true, -- (file x of x) instead of just (x of x
  F = true, -- Don't give file info when editing a file, NOTE: this breaks autocommand messages
  s = true, -- Don't give search hit ... messages
  c = true, -- Don't give ins-completion-menu messages
  W = true, -- Dont show [w] or written when writing
}

-- Timings {{{1
vim.opt.updatetime = 100
vim.opt.timeout = true
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 10

-- Windows and buffers {{{1
vim.opt.fileformats = { 'unix', 'mac', 'dos' }
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.fillchars = {
  vert = '▕',
  eob = '~',
  diff = '░',
  msgsep = '‾',
  fold = ' ',
  foldopen = '▾',
  foldsep = '│',
  foldclose = '▸',
}
-- Diff options {{{1
vim.opt.diffopt:append({
  'vertical',
  'iwhite',
  'hiddenoff',
  'foldcolumn:0',
  'context:4',
  'algorithm:histogram',
  'indent-heuristic',
})

-- Folds {{{1
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldlevelstart = 20 -- Always start editing with no folds closed

-- Display {{{1
vim.opt.confirm = true -- Raise a dialog when an operation has to be confirmed
vim.opt.cursorline = true -- Highlight current line
vim.opt.signcolumn = 'yes:2' -- Always show the signcolumn (2 symbols)
vim.opt.number = true -- Display line numbers
vim.opt.relativenumber = true -- Show the line number relative to the line with the cursor
vim.opt.colorcolumn = '80' -- Set the colored vertical column
vim.opt.cmdheight = 1 -- Set the command-line height to 1
vim.opt.showbreak = '↪ ' -- Show a symbol at the start of wrapped lines
vim.opt.completeopt = { 'menuone', 'noinsert', 'noselect' }
vim.opt.showmode = false -- Don't show mode in cmd
vim.opt.syntax = 'on' -- Enable syntax highlighting
vim.opt.termguicolors = true -- Enable 24-bit RGB color in the TUI

-- List chars {{{1
vim.opt.list = true -- Show special characters
vim.opt.listchars = {
  eol = '↲',
  tab = '→ ',
  extends = '›',
  precedes = '‹',
  trail = '•',
}

-- Indentation {{{1
vim.opt.wrap = true
vim.opt.wrapmargin = 2
vim.opt.expandtab = true -- Use the appropriate number of spaces to insert a <Tab>
vim.opt.autoindent = true -- Copy indent from current line when starting a new line
vim.opt.smarttab = true -- Makes tabbing smarter
vim.opt.smartindent = true -- Makes indentation smarter
vim.opt.tabstop = 4 -- Number of spaces in tab when displaying a file
vim.opt.softtabstop = 4 -- Number of spaces in tab when editing a file
vim.opt.shiftwidth = 4 -- Number of spaces to use for autoindent
vim.opt.joinspaces = false -- Insert only one space with a join command

-- Mouse {{{1
vim.opt.mouse = 'a' -- Enable mouse for all modes
vim.opt.mousefocus = true

-- Match and search {{{1
vim.opt.hlsearch = false
vim.opt.magic = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrapscan = true
vim.opt.scrolloff = 9
vim.opt.sidescrolloff = 10
vim.opt.sidescroll = 1

-- Backup and swap {{{1
vim.opt.undofile = true -- Enable persistent undo
vim.opt.backup = false -- Disable backups
vim.opt.writebackup = false -- Disable backups
vim.opt.swapfile = false -- Disable swapfiles

-- Python {{{1
vim.g.python3_host_prog = '/usr/bin/python3'

--- }}}
