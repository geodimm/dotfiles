vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Save files
vim.keymap.set('n', '<leader>w', ':w<CR>', { noremap = true })
vim.keymap.set('v', '<leader>w', '<Esc>:w<CR>gv', { noremap = true })

-- Quit vim
vim.keymap.set('n', '<leader>q', ':q<CR>', { noremap = true })
vim.keymap.set('v', '<leader>q', '<Esc>:q<CR>gv', { noremap = true })

-- Save with sudo
vim.keymap.set('c', 'w!!', '%!sudo tee > /dev/null %', { noremap = true })

-- Temporary turn off hlsearch
vim.keymap.set('n', '<leader><CR>', ':noh<CR>', { noremap = true, silent = true })

-- Sort lines alphabetically
vim.keymap.set('v', '<leader>S', ':sort<CR>', { noremap = true })

-- Copy with Ctrl+C in visual mode
vim.keymap.set('v', '<C-c>', '"+y<CR>', { noremap = true })

-- Allow pasting the same selection multiple times
-- 'p' to paste, 'gv' to re-select what was originally selected. 'y' to copy it again.
vim.keymap.set('x', 'p', 'pgvy', { noremap = true })

-- Go back to visual mode after reindenting
vim.keymap.set('v', '<', '<gv', { noremap = true })
vim.keymap.set('v', '>', '>gv', { noremap = true })

-- Remap gf to open first file on line
vim.keymap.set('n', 'gf', '^f/gf', { noremap = true })

-- A quick way to move lines of text up or down
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { noremap = true })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { noremap = true })

-- Quickly edit dotfiles
vim.keymap.set('n', '<leader>ev', ':vsplit $MYVIMRC<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>et', ':vsplit ~/dotfiles/tmux/tmux.conf<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>ez', ':vsplit ~/dotfiles/zsh/zshrc<CR>', { noremap = true, silent = true })

-- Exit insert mode with jj
vim.keymap.set('i', 'jj', '<Esc>', { noremap = true, silent = true })

-- Go to the next line in editor for wrapped lines
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : '<Esc>'.v:count.'j'", { noremap = true, expr = true })
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : '<Esc>'.v:count.'k'", { noremap = true, expr = true })

-- Easier navigation through split windows
vim.keymap.set('n', '<C-j>', '<C-w><Down>', { noremap = true })
vim.keymap.set('n', '<C-k>', '<C-w><Up>', { noremap = true })
vim.keymap.set('n', '<C-l>', '<C-w><Right>', { noremap = true })
vim.keymap.set('n', '<C-h>', '<C-w><Left>', { noremap = true })
vim.keymap.set('n', '<C-f>', ':vertical wincmd f<CR>', { noremap = true })

-- Use alt + hjkl to resize windows
vim.keymap.set('n', '<M-j>', ':resize -2<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<M-k>', ':resize +2<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<M-h>', ':vertical resize -10<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<M-l>', ':vertical resize +10<CR>', { noremap = true, silent = true })

-- Remap 0 to go to first non-blank character of the line
vim.keymap.set('n', '0', '^', { noremap = true })

-- Remap Y to apply till EOL, just like D and C.
vim.keymap.set('n', 'Y', 'y$', { noremap = true })

-- Remap ZX to quitall
vim.keymap.set('n', 'ZX', ':qa<CR>', { noremap = true })

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
vim.keymap.set('n', '<leader>b', ':BufOnly<CR>', { noremap = true })

require('utils.whichkey').register({
  mappings = {
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
  },
  opts = {},
}, {
  mappings = {
    ['<leader>S'] = 'Sort selected lines',
    ['<leader>w'] = 'Save',
    ['<leader>q'] = 'Close/Quit',
  },
  opts = { mode = 'v' },
})
