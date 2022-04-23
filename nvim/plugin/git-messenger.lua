vim.g.git_messenger_include_diff = 'current'
vim.g.git_messenger_floating_win_opts = { border = 'single' }
vim.g.git_messenger_always_into_popup = true

local status_ok, wk = pcall(require, 'which-key')
if not status_ok then
  return
end

wk.register({ ['<leader>gm'] = { 'Show git blame' } })
