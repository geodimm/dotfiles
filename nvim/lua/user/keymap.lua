vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

local keymap = require('utils.keymap')

keymap.set('n', '<leader>w', ':w<CR>', { desc = 'Save' })
keymap.set('v', '<leader>w', '<Esc>:w<CR>gv', { desc = 'Save' })
keymap.set('n', '<leader>q', ':q<CR>', { desc = 'Close/Quit' })
keymap.set('v', '<leader>q', '<Esc>:q<CR>gv', { desc = 'Close/Quit' })
keymap.set('n', '<leader><CR>', ':noh<CR>', { desc = 'Turn off search highlights' })
keymap.set('v', '<C-c>', '"+y<CR>', { desc = 'Copy with Ctrl+C in visual mode' })
keymap.set('n', 'J', 'mzJ`z', { desc = 'Join lines but keep cursor position' })
keymap.set('x', 'p', 'pgvy', { desc = 'Allow pasting the same selection multiple times' })
keymap.set('n', 'gf', '^f/gf', { desc = 'Open first file on the current line' })
keymap.set('i', 'jj', '<Esc>', { desc = 'Exit insert mode' })
keymap.set('v', '<', '<gv', { desc = 'Go back to visual mode after reindent' })
keymap.set('v', '>', '>gv', { desc = 'Go back to visual mode after reindent' })
keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })
keymap.set('n', 'j', "v:count == 0 ? 'gj' : '<Esc>'.v:count.'j'", { desc = 'Go to next wrapped line', expr = true })
keymap.set('n', 'k', "v:count == 0 ? 'gk' : '<Esc>'.v:count.'k'", { desc = 'Go to previous wrapped line', expr = true })

keymap.set('n', '<C-f>', ':vertical wincmd f<CR>', { desc = 'Open file under cursor' })
keymap.set('n', '<M-j>', ':resize -2<CR>', { desc = 'Decrease window height' })
keymap.set('n', '<M-k>', ':resize +2<CR>', { desc = 'Increase window height' })
keymap.set('n', '<M-h>', ':vertical resize -10<CR>', { desc = 'Decrease window width' })
keymap.set('n', '<M-l>', ':vertical resize +10<CR>', { desc = 'Increase window width' })
keymap.set('n', '0', '^', { desc = 'Go to first non-whitespace character of the line' })
keymap.set('n', 'Y', 'y$', { desc = 'Yank til end of line' })
keymap.set('n', 'ZX', ':qa<CR>', { desc = 'Quitall' })
keymap.set('n', 'z=', function()
  local cursor_word = vim.fn.expand('<cword>')
  local bad = vim.fn.spellbadword(cursor_word)
  local word = bad[1]
  if word == '' then
    word = cursor_word
  end

  local suggestions = vim.fn.spellsuggest(word, 25, bad[2] == 'caps' and 1 or 0)

  local function selected(item)
    if item then
      vim.api.nvim_feedkeys('ciw' .. item, 'n', true)
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, true, true), 'n', true)
    end
  end

  vim.ui.select(suggestions, { kind = 'spellsuggest' }, vim.schedule_wrap(selected))
end)

-- Abbreviations
vim.api.nvim_command('iab cdate <c-r>=strftime("%Y-%m-%d")<CR>')
vim.api.nvim_command('iab todo <c-r>="TODO (Georgi Dimitrov):"<CR>')
