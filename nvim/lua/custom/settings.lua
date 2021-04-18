-- Interface
vim.o.confirm = true        -- Raise a dialog when an operation has to be confirmed
vim.o.splitbelow = true     -- Open splitpanes below
vim.o.splitright = true     -- Open splitpanes to the right
vim.o.cursorline = true     -- Highlight current line
vim.o.updatetime = 100      -- Faster CursorHold
vim.o.signcolumn = "yes:2"  -- Always show the signcolumn (2 symbols)
vim.o.number = true         -- Display line numbers
vim.o.relativenumber = true -- Show the line number relative to the line with the cursor
vim.o.hlsearch = false      -- Stop the highlighting for the 'hlsearch'
vim.o.colorcolumn = "80"    -- Set the colored vertical column
vim.o.cmdheight = 2         -- Set the command-line height to 2
vim.o.showbreak = "↪ "      -- Show a symbol at the start of wrapped lines
vim.o.list = true           -- Show special characters
vim.o.listchars = "tab:→ ,nbsp:␣,trail:•,eol:↲,precedes:«,extends:»"

-- Toggle highlighting current line only in active splits
vim.api.nvim_exec([[
augroup toggle_current_line_hl
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    autocmd WinLeave *                      setlocal nocursorline
augroup end
]], false)

-- Features
vim.o.mouse = "a"           -- Enable mouse for all modes
vim.o.modeline = true       -- Set filetype specific options via modelines
vim.o.undofile = true       -- Enable persistent undo
vim.o.backup = false        -- Disable backups
vim.o.writebackup = false   -- Disable backups
vim.o.swapfile = false      -- Disable swapfiles
vim.o.ffs = "unix,mac,dos"  -- Use Unix as the standard file format
vim.o.magic = true          -- Regex and search options
vim.o.foldmethod = "syntax" -- Syntax highlighting items specify folds
vim.o.foldlevelstart = 99   -- Always start editing with no folds closed

-- Wrap lines to 72 characters in git commit messages and use 2 spaces for tab
vim.api.nvim_exec([[
augroup gitcommit_filetype_settings
    autocmd!
    autocmd FileType gitcommit setlocal spell textwidth=72 shiftwidth=2 tabstop=2 colorcolumn=+1 colorcolumn+=51
augroup end
]], false)

-- Editor
vim.o.expandtab = true                          -- Use the appropriate number of spaces to insert a <Tab>
vim.o.autoindent = true                         -- Copy indent from current line when starting a new line
vim.o.smarttab = true                           -- Makes tabbing smarter
vim.o.smartindent = true                        -- Makes indentation smarter
vim.o.tabstop = 4                               -- Number of spaces in tab when displaying a file
vim.o.softtabstop = 4                           -- Number of spaces in tab when editing a file
vim.o.shiftwidth = 4                            -- Number of spaces to use for autoindent
vim.o.joinspaces = false                        -- Insert only one space with a join command
vim.o.shortmess = vim.o.shortmess .. "c"        -- Don't pass messages to |ins-completion-menu|
vim.o.completeopt = "menuone,noinsert,noselect" -- Don't select the first completion item; show even if there's only one match

-- Global
vim.g.python3_host_prog = "/usr/bin/python3"
