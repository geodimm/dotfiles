local status_ok, lightbulb = pcall(require, 'nvim-lightbulb')
if not status_ok then
  return
end

lightbulb.setup({ autocmd = { enabled = true } })
