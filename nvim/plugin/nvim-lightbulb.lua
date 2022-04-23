local status_ok, lightbulb = pcall(require, 'nvim-lightbulb')
if not status_ok then
  return
end

vim.api.nvim_create_augroup('update_lightbulb', { clear = true })
vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
  group = 'update_lightbulb',
  pattern = '*',
  callback = function()
    lightbulb.update_lightbulb()
  end,
})
