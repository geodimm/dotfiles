local status_ok, colorizer = pcall(require, 'colorizer')
if not status_ok then
  return
end

vim.opt.termguicolors = true -- Enable 24-bit RGB color in the TUI
colorizer.setup({})
