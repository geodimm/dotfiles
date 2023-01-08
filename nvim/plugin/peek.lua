local status_ok, peek
status_ok, peek = pcall(require, 'peek')
if not status_ok then
  return
end

peek.setup({})

vim.api.nvim_create_user_command('PeekOpen', peek.open, {})
vim.api.nvim_create_user_command('PeekClose', peek.close, {})
