vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Save files
vim.api.nvim_set_keymap('n', '<leader>w', ':w<CR>', { noremap = true })
vim.api.nvim_set_keymap('v', '<leader>w', '<Esc>:w<CR>gv', { noremap = true })

-- Quit vim
vim.api.nvim_set_keymap('n', '<leader>q', ':q<CR>', { noremap = true })
vim.api.nvim_set_keymap('v', '<leader>q', '<Esc>:q<CR>gv', { noremap = true })

-- Save with sudo
vim.api.nvim_set_keymap('c', 'w!!', '%!sudo tee > /dev/null %', { noremap = true })

-- Temporary turn off hlsearch
vim.api.nvim_set_keymap('n', '<leader><CR>', ':noh<CR>', { noremap = true, silent = true })

-- Sort lines alphabetically
vim.api.nvim_set_keymap('v', '<leader>S', ':sort<CR>', { noremap = true })

-- Copy with Ctrl+C in visual mode
vim.api.nvim_set_keymap('v', '<C-c>', '"+y<CR>', { noremap = true })

-- Allow pasting the same selection multiple times
-- 'p' to paste, 'gv' to re-select what was originally selected. 'y' to copy it again.
vim.api.nvim_set_keymap('x', 'p', 'pgvy', { noremap = true })

-- Go back to visual mode after reindenting
vim.api.nvim_set_keymap('v', '<', '<gv', { noremap = true })
vim.api.nvim_set_keymap('v', '>', '>gv', { noremap = true })

-- Remap gf to open first file on line
vim.api.nvim_set_keymap('n', 'gf', '^f/gf', { noremap = true })

-- A quick way to move lines of text up or down
vim.api.nvim_set_keymap('v', '<A-j>', ":m '>+1<CR>gv=gv", { noremap = true })
vim.api.nvim_set_keymap('v', '<A-k>', ":m '<-2<CR>gv=gv", { noremap = true })

-- Quickly edit dotfiles
vim.api.nvim_set_keymap('n', '<leader>ev', ':vsplit $MYVIMRC<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>et', ':vsplit ~/dotfiles/tmux/tmux.conf<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ez', ':vsplit ~/dotfiles/zsh/zshrc<CR>', { noremap = true, silent = true })

-- Exit insert mode with jj
vim.api.nvim_set_keymap('i', 'jj', '<Esc>', { noremap = true, silent = true })

-- Go to the next line in editor for wrapped lines
vim.api.nvim_set_keymap('n', 'j', "v:count == 0 ? 'gj' : '<Esc>'.v:count.'j'", { noremap = true, expr = true })
vim.api.nvim_set_keymap('n', 'k', "v:count == 0 ? 'gk' : '<Esc>'.v:count.'k'", { noremap = true, expr = true })

-- Easier navigation through split windows
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w><Down>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w><Up>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w><Right>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w><Left>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-f>', ':vertical wincmd f<CR>', { noremap = true })

-- Use alt + hjkl to resize windows
vim.api.nvim_set_keymap('n', '<M-j>', ':resize -2<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-k>', ':resize +2<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-h>', ':vertical resize -10<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-l>', ':vertical resize +10<CR>', { noremap = true, silent = true })

-- Remap 0 to go to first non-blank character of the line
vim.api.nvim_set_keymap('', '0', '^', { noremap = true })

-- Remap Y to apply till EOL, just like D and C.
vim.api.nvim_set_keymap('', 'Y', 'y$', { noremap = true })

-- Remap ZX to quitall
vim.api.nvim_set_keymap('n', 'ZX', ':qa<CR>', { noremap = true })

-- Abbreviations
vim.api.nvim_command('iab cdate <c-r>=strftime("%Y-%m-%d")<CR>')
vim.api.nvim_command('iab todo <c-r>="TODO (Georgi Dimitrov):"<CR>')

-- Formal XML
vim.api.nvim_exec(
  [[
command! FormatXML silent! execute '%!python3 -c "import xml.dom.minidom, sys; print(xml.dom.minidom.parse(sys.stdin).toprettyxml())'
    ]],
  false
)

-- Formal JSON
vim.api.nvim_exec(
  [[
command! FormatJSON silent! execute '%!python3 -m json.tool'
    ]],
  false
)

-- Close all buffers but the current one
vim.api.nvim_exec(
  [[
command! BufOnly silent! execute "%bd|e#|bd#"
    ]],
  false
)
vim.api.nvim_set_keymap('', '<leader>b', ':BufOnly<CR>', { noremap = true })

local status_ok, wk = pcall(require, 'which-key')
if not status_ok then
  return
end

wk.register({
  ['<C-f>'] = 'Open file under cursor',
  ['<C-h>'] = 'Move left',
  ['<C-j>'] = 'Move down',
  ['<C-k>'] = 'Move up',
  ['<C-l>'] = 'Move right',
  ['<C-\\>'] = 'Switch to last window',
  ['<M-h>'] = 'Shrink window horizontally',
  ['<M-j>'] = 'Shrink window vertically',
  ['<M-k>'] = 'Expand window vertically',
  ['<M-l>'] = 'Expand window horizontally',
  ['<leader><CR>'] = 'Disable highlighting',
  ['<leader>w'] = 'Save',
  ['<leader>q'] = 'Close/Quit',
  ['<leader>b'] = 'Close all other buffers',
  ['<leader>e'] = {
    name = '+vsplit',
    v = 'init.lua',
    t = 'tmux.conf',
    z = 'zshrc',
  },
  Y = 'Yank til end of line',
})
wk.register({
  ['<leader>S'] = 'Sort selected lines',
  ['<leader>w'] = 'Save',
  ['<leader>q'] = 'Close/Quit',
}, { mode = 'v' })
