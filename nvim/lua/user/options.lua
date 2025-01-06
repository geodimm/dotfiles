-- vim: foldmethod=marker
-- Message output on vim actions {{{1

-- The neovim default is "filnxtToOF"
vim.opt.shortmess = {
  f = false, -- use "(3 of 5)" instead of "(file 3 of 5)"
  i = false, -- use "[noeol]" instead of "[Incomplete last line]"
  l = false, -- use "999L, 888B" instead of "999 lines, 888 bytes"
  m = false, -- use "[+]" instead of "[Modified]"
  n = false, -- use "[New]" instead of "[New File]"
  r = false, -- use "[RO]" instead of "[readonly]"
  w = false, -- use "[w]" instead of "written" for file write message and and "[a]" instead of "appended" for ':w >> file' command
  x = false, -- use "[dos]" instead of "[dos format]", "[unix]" instead of "[unix format]" and "[mac]" instead of "[mac format]"
  a = true, -- all of the above abbreviations
  o = true, -- overwrite message for writing a file with subsequent message for reading a file (useful for ":wn" or when 'autowrite' on)
  O = true, -- message for reading a file overwrites any previous message;  also for quickfix message (e.g., ":cn")
  s = true, -- don't give "search hit BOTTOM, continuing at TOP" or "search hit TOP, continuing at BOTTOM" messages; when using the search count do not show "W" after the count message (see S below)
  t = true, -- truncate file message at the start if it is too long to fit on the command-line, "<" will appear in the left most column; ignored in Ex mode
  T = true, -- truncate non-file messages in middle if they are too long to fit on the command line; "..." will appear in the middle; ignored in Ex mode
  W = false, -- don't give "written" or "[w]" when writing a file
  A = true, -- don't give the "ATTENTION" message when an existing swap file is found
  I = true, -- don't give the intro message when starting Vim, see :intro
  c = true, -- don't give |ins-completion-menu| messages; for example,, "-- XXX completion (YYY)", "match 1 of 2", "The only match", "Pattern not found", "Back at original", etc.
  C = true, -- don't give messages while scanning for ins-completion items, for instance "scanning tags"
  q = false, -- use "recording" instead of "recording @a"
  F = true, -- don't give file info when editing a file, like `:silent` was used for the command
  S = false, -- do not show search count message when searching, e.g. "[1/5]"
}

-- Timings {{{1
vim.opt.updatetime = 50
vim.opt.timeout = true
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 10

-- Windows and buffers {{{1
vim.opt.fileformats = { 'unix', 'mac', 'dos' }
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.fillchars = {
  diff = '░',
  msgsep = '‾',
  fold = ' ',
  foldopen = '▾',
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
vim.o.foldcolumn = 'auto'
vim.o.foldmethod = 'indent'
vim.o.foldlevel = 99
vim.o.foldenable = false

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
  tab = '  ',
  trail = '•',
}

-- Indentation {{{1
vim.opt.wrap = false -- wrap lines longer than the width of the window
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
vim.opt.mousemodel = 'extend'

-- Match and search {{{1
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.magic = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.scrolloff = 9
vim.opt.sidescrolloff = 10
vim.opt.isfname:append('@-@')

-- Backup and swap {{{1
vim.opt.undofile = true -- Enable persistent undo
vim.opt.backup = false -- Disable backups
vim.opt.writebackup = false -- Disable backups
vim.opt.swapfile = false -- Disable swapfiles

--- }}}
