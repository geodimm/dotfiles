-- vim: foldmethod=marker

-- Toggle highlighting current line only in active splits {{{1
vim.api.nvim_create_augroup('user_toggle_cursorline', { clear = true })
vim.api.nvim_create_autocmd({ 'VimEnter', 'WinEnter', 'BufWinEnter' }, {
  group = 'user_toggle_cursorline',
  desc = 'enable cursorline on focus',
  pattern = '*',
  callback = function()
    vim.cmd(':setlocal cursorline')
  end,
})
vim.api.nvim_create_autocmd('VimLeave', {
  group = 'user_toggle_cursorline',
  desc = 'disable cursorline on lost focus',
  pattern = '*',
  callback = function()
    vim.cmd(':setlocal nocursorline')
  end,
})

-- Customise colorscheme highlight groups {{{1
vim.api.nvim_create_augroup('user_customise_colorscheme', { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', {
  group = 'user_customise_colorscheme',
  desc = 'customise the colorscheme highlights',
  pattern = '*',
  callback = function()
    vim.api.nvim_set_hl(0, 'PmenuThumb', { link = 'Visual' })
  end,
})

--- }}}
