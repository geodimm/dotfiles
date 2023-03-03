-- vim: foldmethod=marker
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- Use a protected call so we don't error out on first use
local status_ok, lazy = pcall(require, 'lazy')
if not status_ok then
  return
end

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

require('user.options')
require('user.autocmd')
require('user.keymaps')
require('user.command')

lazy.setup({
  { import = 'plugins' },
}, {
  ui = {
    border = 'rounded',
  },
  install = {
    colorscheme = { 'catppuccin-macchiato' },
  },
})
