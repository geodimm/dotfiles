-- vim: foldmethod=marker
-- Monotonic t0; `user.pack` sets `vim.g._nvim_pack_startup_ms` when plugin setup finishes.
vim.g._nvim_start_hrtime_ms = (vim.uv or vim.loop).hrtime() / 1e6

require('user.options')
require('user.keymap')
require('user.autocmd')
require('user.command')

require('user.pack').setup()
