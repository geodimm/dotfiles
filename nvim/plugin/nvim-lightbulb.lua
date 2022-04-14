vim.api.nvim_create_augroup('update_lightbulb', { clear = true })
vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
  group = 'update_lightbulb',
  pattern = '*',
  callback = function()
    require('nvim-lightbulb').update_lightbulb()
  end,
})
