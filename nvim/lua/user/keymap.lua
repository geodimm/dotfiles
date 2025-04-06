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

-- Toggle terminal
vim.keymap.set(
  { 'n', 't' },
  '<leader>tt',
  (function()
    local buf, win = nil, nil
    local was_insert = true
    local cfg = function()
      return {
        relative = 'editor',
        width = math.floor(vim.o.columns * 0.8),
        height = math.floor(vim.o.lines * 0.8),
        row = math.floor(vim.o.lines * 0.1),
        col = math.floor(vim.o.columns * 0.1),
        style = 'minimal',
        border = 'rounded',
      }
    end
    return function()
      buf = (buf and vim.api.nvim_buf_is_valid(buf)) and buf or nil
      win = (win and vim.api.nvim_win_is_valid(win)) and win or nil
      if not buf and not win then
        vim.cmd('split | terminal')
        buf = vim.api.nvim_get_current_buf()
        vim.api.nvim_win_close(vim.api.nvim_get_current_win(), true)
        win = vim.api.nvim_open_win(buf, true, cfg())
      elseif not win and buf then
        win = vim.api.nvim_open_win(buf, true, cfg())
      elseif win then
        was_insert = vim.api.nvim_get_mode().mode == 't'
        return vim.api.nvim_win_close(win, true)
      end
      if was_insert then
        vim.cmd('startinsert')
      end
    end
  end)(),
  { desc = 'Floating terminal' }
)
