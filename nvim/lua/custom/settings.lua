-- Interface
vim.opt.confirm = true -- Raise a dialog when an operation has to be confirmed
vim.opt.splitbelow = true -- Open splitpanes below
vim.opt.splitright = true -- Open splitpanes to the right
vim.opt.cursorline = true -- Highlight current line
vim.opt.updatetime = 100 -- Faster CursorHold
vim.opt.signcolumn = "yes:2" -- Always show the signcolumn (2 symbols)
vim.opt.number = true -- Display line numbers
vim.opt.relativenumber = true -- Show the line number relative to the line with the cursor
vim.opt.hlsearch = false -- Stop the highlighting for the 'hlsearch'
vim.opt.colorcolumn = "80" -- Set the colored vertical column
vim.opt.cmdheight = 2 -- Set the command-line height to 2
vim.opt.showbreak = "↪ " -- Show a symbol at the start of wrapped lines
vim.opt.list = true -- Show special characters
vim.opt.listchars = "tab:→ ,nbsp:␣,trail:•,eol:↲,precedes:«,extends:»"

-- Toggle highlighting current line only in active splits
vim.api.nvim_exec([[
augroup toggle_current_line_hl
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    autocmd WinLeave *                      setlocal nocursorline
augroup end
]], false)

-- Features
vim.opt.mouse = "a" -- Enable mouse for all modes
vim.opt.modeline = true -- Set filetype specific options via modelines
vim.opt.undofile = true -- Enable persistent undo
vim.opt.backup = false -- Disable backups
vim.opt.writebackup = false -- Disable backups
vim.opt.swapfile = false -- Disable swapfiles
vim.opt.ffs = "unix,mac,dos" -- Use Unix as the standard file format
vim.opt.magic = true -- Regex and search options
vim.opt.foldmethod = "syntax" -- Syntax highlighting items specify folds
vim.opt.foldlevelstart = 99 -- Always start editing with no folds closed

-- Wrap lines to 72 characters in git commit messages and use 2 spaces for tab
vim.api.nvim_exec([[
augroup gitcommit_filetype_settings
    autocmd!
    autocmd FileType gitcommit setlocal spell textwidth=72 shiftwidth=2 tabstop=2 colorcolumn=+1 colorcolumn+=51
augroup end
]], false)

-- Editor
vim.opt.expandtab = true -- Use the appropriate number of spaces to insert a <Tab>
vim.opt.autoindent = true -- Copy indent from current line when starting a new line
vim.opt.smarttab = true -- Makes tabbing smarter
vim.opt.smartindent = true -- Makes indentation smarter
vim.opt.tabstop = 4 -- Number of spaces in tab when displaying a file
vim.opt.tabstop = 4 -- Number of spaces in tab when displaying a file
vim.opt.softtabstop = 4 -- Number of spaces in tab when editing a file
vim.opt.softtabstop = 4 -- Number of spaces in tab when editing a file
vim.opt.shiftwidth = 4 -- Number of spaces to use for autoindent
vim.opt.shiftwidth = 4 -- Number of spaces to use for autoindent
vim.opt.joinspaces = false -- Insert only one space with a join command
vim.opt.shortmess = vim.o.shortmess .. "c" -- Don't pass messages to |ins-completion-menu|
vim.opt.completeopt = "menuone,noinsert,noselect" -- Don't select the first completion item; show even if there's only one match

-- Global
vim.g.python3_host_prog = "/usr/bin/python3"
