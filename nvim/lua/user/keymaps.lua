M = {}

local status_ok, wk
status_ok, wk = pcall(require, 'which-key')

-- Set calls vim.keymap.set with sensible opts.
local function set(mode, lhs, rhs, opts)
  opts = opts or {}
  if opts.silent == nil then
    opts.silent = true
  end

  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Register group assigns a name for a keymap prefix in which-key
local function register_group(prefix, name, opts)
  if not status_ok then
    return
  end

  wk.register({ [prefix] = { name = name } }, opts)
end

set('n', '<leader>w', ':w<CR>', { desc = 'Save' })
set('v', '<leader>w', '<Esc>:w<CR>gv', { desc = 'Save' })
set('n', '<leader>q', ':q<CR>', { desc = 'Close/Quit' })
set('v', '<leader>q', '<Esc>:q<CR>gv', { desc = 'Close/Quit' })
set('n', '<leader><CR>', ':noh<CR>', { desc = 'Turn off search highlights' })
set('v', '<C-c>', '"+y<CR>', { desc = 'Copy with Ctrl+C in visual mode' })
set('x', 'p', 'pgvy', { desc = 'Allow pasting the same selection multiple times' })
set('n', 'gf', '^f/gf', { desc = 'Open first file on the current line' })
set('i', 'jj', '<Esc>', { desc = 'Exit insert mode' })

set('v', '<', '<gv', { desc = 'Go back to visual mode after reindent' })
set('v', '>', '>gv', { desc = 'Go back to visual mode after reindent' })

set('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
set('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

set('n', 'j', "v:count == 0 ? 'gj' : '<Esc>'.v:count.'j'", { desc = 'Go to next wrapped line', expr = true })
set('n', 'k', "v:count == 0 ? 'gk' : '<Esc>'.v:count.'k'", { desc = 'Go to previous wrapped line', expr = true })

-- Don't override vim-kitty-navigator key bindings
-- set('n', '<C-j>', '<C-w><Down>', { desc = 'Move down' })
-- set('n', '<C-k>', '<C-w><Up>', { desc = 'Move up' })
-- set('n', '<C-l>', '<C-w><Right>', { desc = 'Move right' })
-- set('n', '<C-h>', '<C-w><Left>', { desc = 'Move left' })
set('n', '<C-f>', ':vertical wincmd f<CR>', { desc = 'Open file under cursor' })

set('n', '<M-j>', ':resize -2<CR>', { desc = 'Decrease window height' })
set('n', '<M-k>', ':resize +2<CR>', { desc = 'Increase window height' })
set('n', '<M-h>', ':vertical resize -10<CR>', { desc = 'Decrease window width' })
set('n', '<M-l>', ':vertical resize +10<CR>', { desc = 'Increase window width' })

set('n', '0', '^', { desc = 'Go to first non-whitespace character of the line' })
set('n', 'Y', 'y$', { desc = 'Yank til end of line' })
set('n', 'ZX', ':qa<CR>', { desc = 'Quitall' })

set('n', 'z=', function()
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

M.set = set
M.register_group = register_group

return M
