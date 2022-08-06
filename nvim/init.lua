-- vim: foldmethod=marker
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local packer_bootstrap = false

if vim.fn.empty(vim.fn.glob(install_path, nil, nil, nil)) > 0 then
  vim.o.runtimepath = vim.fn.stdpath('data') .. '/site/pack/*/start/*,' .. vim.o.runtimepath
  packer_bootstrap = vim.fn.system({
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  })
end

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, 'packer')
if not status_ok then
  return
end

vim.api.nvim_create_augroup('user_packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  group = 'user_packer',
  desc = 'run packer.compile() on save',
  pattern = 'init.lua',
  callback = function()
    packer.compile()
  end,
})

packer.startup({
  function(use)
    -- Vanity {{{1
    use('wbthomason/packer.nvim')
    use('goolord/alpha-nvim')
    use('hoob3rt/lualine.nvim')
    use('folke/tokyonight.nvim')
    use({ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' })
    use('nvim-treesitter/nvim-treesitter-textobjects')
    use('kyazdani42/nvim-web-devicons')
    use({ 'RRethy/vim-hexokinase', run = 'make hexokinase' })
    use({ 'Pocco81/true-zen.nvim', branch = 'dev' })

    -- IDE-like features {{{1
    use('kyazdani42/nvim-tree.lua')
    use({ 'akinsho/nvim-toggleterm.lua', branch = 'main' })
    use('stevearc/dressing.nvim')
    use('rcarriga/nvim-notify')
    use('rhysd/git-messenger.vim')
    use('tpope/vim-fugitive')
    use('folke/which-key.nvim')
    use('FooSoft/vim-argwrap')
    use({ 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } })

    use({
      'windwp/nvim-spectre',
      requires = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' },
    })
    use({
      'nvim-telescope/telescope.nvim',
      requires = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' },
    })
    use({
      'nvim-telescope/telescope-fzf-native.nvim',
      requires = { 'nvim-telescope/telescope.nvim' },
      run = 'make',
    })
    use({
      'gbrlsnchs/telescope-lsp-handlers.nvim',
      requires = { 'nvim-telescope/telescope.nvim' },
    })
    use({
      'folke/trouble.nvim',
      requires = { 'kyazdani42/nvim-web-devicons' },
    })
    use({
      'ThePrimeagen/refactoring.nvim',
      requires = { 'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter' },
    })

    -- Tmux integration {{{1
    use('tmux-plugins/vim-tmux')
    use('urbainvaes/vim-tmux-pilot')

    -- Text editing features {{{1
    use('kylechui/nvim-surround')
    use('tpope/vim-commentary')
    use('tpope/vim-repeat')

    -- " Languages/LSP {{{1
    use('neovim/nvim-lspconfig')
    use('williamboman/nvim-lsp-installer')
    use({ 'jose-elias-alvarez/null-ls.nvim', requires = { 'nvim-lua/plenary.nvim' } })
    use('kosayoda/nvim-lightbulb')
    use('folke/lua-dev.nvim')

    -- Autocompletion {{{2
    use('hrsh7th/nvim-cmp')
    use('hrsh7th/cmp-nvim-lsp')
    use('hrsh7th/cmp-nvim-lsp-signature-help')
    use('hrsh7th/cmp-buffer')
    use('hrsh7th/cmp-path')
    use('hrsh7th/cmp-nvim-lua')
    use({ 'petertriho/cmp-git', requires = { 'nvim-lua/plenary.nvim' } })
    use('L3MON4D3/LuaSnip')
    use({
      'saadparwaiz1/cmp_luasnip',
      requires = { 'hrsh7th/nvim-cmp', 'L3MON4D3/LuaSnip' },
    })
    use('rafamadriz/friendly-snippets')
    use('onsails/lspkind-nvim')
    -- }}}
    use({
      'olexsmir/gopher.nvim',
      requires = {
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
      },
    })
    use('hashivim/vim-terraform')
    use('towolf/vim-helm')
    use('bfrg/vim-jq')
    use('Joorem/vim-haproxy')
    use('preservim/vim-markdown')
    use('godlygeek/tabular') -- required to format Markdown tables
    use('mracos/mermaid.vim')
    use({
      'iamcco/markdown-preview.nvim',
      run = function()
        vim.fn['mkdp#util#install']()
      end,
    })
    -- }}}

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
      packer.sync()
    end
  end,
  config = {
    display = {
      prompt_border = 'rounded',
      open_fn = function()
        return require('packer.util').float({ border = 'rounded' })
      end,
    },
  },
})

require('user.autocmd')
require('user.options')
require('user.keymaps')
require('user.command')
require('user.colorscheme').setup()
