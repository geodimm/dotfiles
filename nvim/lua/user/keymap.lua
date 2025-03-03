vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

local keymap = require('utils.keymap')

keymap.set('n', '<leader>w', ':w<CR>', { desc = 'Save buffer' })
keymap.set('v', '<leader>w', '<Esc>:w<CR>gv', { desc = 'Save buffer' })
keymap.set('n', '<leader>q', ':q<CR>', { desc = 'Close/Quit' })
keymap.set('v', '<leader>q', '<Esc>:q<CR>gv', { desc = 'Close/Quit' })
keymap.set('n', '<leader><CR>', ':noh<CR>', { desc = 'Turn off search highlights' })
keymap.set('v', '<C-c>', '"+y<CR>', { desc = 'Copy with Ctrl+C in visual mode' })
keymap.set('n', 'J', 'mzJ`z', { desc = 'Join lines but keep cursor position' })
keymap.set('v', 'p', 'pgvy', { desc = 'Allow pasting the same selection multiple times' })
keymap.set('n', 'gf', '^f/gf', { desc = 'Open first file on the current line' })
keymap.set('i', 'jj', '<Esc>', { desc = 'Exit insert mode' })
keymap.set('v', '<', '<gv', { desc = 'Go back to visual mode after reindent' })
keymap.set('v', '>', '>gv', { desc = 'Go back to visual mode after reindent' })
keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })
keymap.set('n', 'j', "v:count == 0 ? 'gj' : '<Esc>'.v:count.'j'", { desc = 'Go to next wrapped line', expr = true })
keymap.set('n', 'k', "v:count == 0 ? 'gk' : '<Esc>'.v:count.'k'", { desc = 'Go to previous wrapped line', expr = true })

keymap.set('n', '<C-f>', ':vertical wincmd f<CR>', { desc = 'Open file under cursor' })
keymap.set('n', '0', '^', { desc = 'Go to first non-whitespace character of the line' })
keymap.set('n', 'Y', 'y$', { desc = 'Yank til end of line' })
keymap.set('n', 'ZX', ':qa<CR>', { desc = 'Quitall' })

-- Abbreviations
vim.api.nvim_command('iab cdate <c-r>=strftime("%Y-%m-%d")<CR>')
vim.api.nvim_command('iab todo <c-r>="TODO (Georgi Dimitrov):"<CR>')
