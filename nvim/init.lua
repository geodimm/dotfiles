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

lazy.setup({
  -- Vanity {{{1
  { 'goolord/alpha-nvim' },
  { 'hoob3rt/lualine.nvim' },
  { 'folke/tokyonight.nvim' },
  { 'catppuccin/nvim', name = 'catppuccin' },
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
  { 'nvim-treesitter/nvim-treesitter-textobjects' },
  { 'kyazdani42/nvim-web-devicons' },
  { 'RRethy/vim-hexokinase', build = 'make hexokinase' },

  -- IDE-like features {{{1
  { 'kyazdani42/nvim-tree.lua' },
  { 'akinsho/nvim-toggleterm.lua', branch = 'main' },
  { 'stevearc/dressing.nvim' },
  { 'rcarriga/nvim-notify' },
  { 'rhysd/git-messenger.vim' },
  { 'tpope/vim-fugitive' },
  { 'folke/which-key.nvim' },
  { 'FooSoft/vim-argwrap' },
  { 'lewis6991/gitsigns.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
  { 'junegunn/vim-easy-align' },

  {
    'windwp/nvim-spectre',
    dependencies = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' },
  },
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' },
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    build = 'make',
  },
  {
    'gbrlsnchs/telescope-lsp-handlers.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
  },
  {
    'folke/trouble.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
  },
  {
    'ThePrimeagen/refactoring.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter' },
  },

  -- Tmux integration {{{1
  { 'tmux-plugins/vim-tmux' },
  { 'urbainvaes/vim-tmux-pilot' },

  -- Text editing features {{{1
  { 'kylechui/nvim-surround' },
  { 'tpope/vim-commentary' },
  { 'tpope/vim-repeat' },

  -- " Languages/LSP {{{1
  { 'neovim/nvim-lspconfig' },
  {
    'SmiteshP/nvim-navic',
    dependencies = { 'neovim/nvim-lspconfig' },
  },
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },
  { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
  { 'jose-elias-alvarez/null-ls.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
  { 'kosayoda/nvim-lightbulb' },
  { 'folke/neodev.nvim' },
  { 'mfussenegger/nvim-jdtls' },

  -- Autocompletion {{{2
  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-nvim-lsp-signature-help' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'hrsh7th/cmp-nvim-lua' },
  { 'petertriho/cmp-git', dependencies = { 'nvim-lua/plenary.nvim' } },
  { 'L3MON4D3/LuaSnip' },
  {
    'saadparwaiz1/cmp_luasnip',
    dependencies = { 'hrsh7th/nvim-cmp', 'L3MON4D3/LuaSnip' },
  },
  { 'rafamadriz/friendly-snippets' },
  { 'onsails/lspkind-nvim' },
  -- }}}
  {
    'olexsmir/gopher.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
  },
  { 'towolf/vim-helm' },
  { 'bfrg/vim-jq' },
  { 'mracos/mermaid.vim' },
  {
    'iamcco/markdown-preview.nvim',
    build = function()
      vim.fn['mkdp#util#install']()
    end,
  },
  -- }}}
}, {
  ui = {
    border = 'rounded',
  },
})

require('user.autocmd')
require('user.options')
require('user.keymaps')
require('user.command')
require('user.colorscheme').setup()
