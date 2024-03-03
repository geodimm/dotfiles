-- vim: foldmethod=marker

-- Toggle highlighting current line only in active splits {{{1
vim.api.nvim_create_autocmd({ 'VimEnter', 'WinEnter', 'BufWinEnter', 'VimLeave', 'WinLeave', 'BufWinLeave' }, {
  group = vim.api.nvim_create_augroup('user_toggle_cursorline', { clear = true }),
  desc = 'toggle cursorline on focus',
  pattern = '*',
  callback = function(ev)
    vim.opt_local.cursorline = ev.event:find('Enter') ~= nil
  end,
})

-- Highlight yanked text {{{1
vim.api.nvim_create_autocmd({ 'TextYankPost' }, {
  group = vim.api.nvim_create_augroup('user_highlight_yank', { clear = true }),
  desc = 'highlight yanked text',
  callback = function()
    vim.highlight.on_yank({ higroup = 'Visual', timeout = 500 })
  end,
})

-- Set filetype to helm for YAML files in certain locations {{{1
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  group = vim.api.nvim_create_augroup('user_filetype_helm', { clear = true }),
  desc = 'set filetype to helm for YAML files in certain locations',
  pattern = { '*/templates/*.yaml', '*/templates/*.tpl' },
  callback = function()
    vim.opt_local.filetype = 'helm'
  end,
})

--- }}}
