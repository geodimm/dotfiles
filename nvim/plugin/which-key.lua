local status_ok, which_key = pcall(require, 'which-key')
if not status_ok then
  return
end

which_key.setup({
  plugins = { spelling = { enabled = true } },
  window = { border = 'single', margin = { 0, 0, 0, 0 }, padding = { 1, 1, 1, 1 } },
})
