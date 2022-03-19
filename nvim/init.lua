-- vim: foldmethod=marker
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.api.nvim_command('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

vim.api.nvim_exec(
  [[
augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
augroup end
]],
  false
)

local use = require('packer').use
require('packer').startup({
  function()
    -- Vanity {{{1
    use('wbthomason/packer.nvim')
    use('mhinz/vim-startify')
    use('akinsho/nvim-bufferline.lua')
    use('hoob3rt/lualine.nvim')
    use('gruvbox-community/gruvbox')
    use('arcticicestudio/nord-vim')
    use('navarasu/onedark.nvim')
    use('folke/tokyonight.nvim')
    use('Mofiqul/vscode.nvim')
    use({ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' })
    use('nvim-treesitter/nvim-treesitter-textobjects')
    use('kyazdani42/nvim-web-devicons')
    use({ 'RRethy/vim-hexokinase', run = 'make hexokinase' })

    -- IDE-like features {{{1
    use('kyazdani42/nvim-tree.lua')
    use({ 'akinsho/nvim-toggleterm.lua' })
    use('rhysd/git-messenger.vim')
    use('tpope/vim-fugitive')
    use('folke/which-key.nvim')
    use({ 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } })

    use({
      'windwp/nvim-spectre',
      requires = { { 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' } },
    })
    use({
      'nvim-telescope/telescope.nvim',
      requires = { { 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' } },
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
    use('kosayoda/nvim-lightbulb')

    -- Tmux integration {{{1
    use('tmux-plugins/vim-tmux')
    use('urbainvaes/vim-tmux-pilot')

    -- Text editing features {{{1
    use('mbbill/undotree')
    use('tpope/vim-surround')
    use('tpope/vim-commentary')
    use('tpope/vim-repeat')

    -- " Languages/LSP {{{1
    use({ 'neovim/nvim-lspconfig' })
    use({ 'williamboman/nvim-lsp-installer' })

    -- Autocompletion {{{2
    use('hrsh7th/nvim-cmp')
    use('hrsh7th/cmp-nvim-lsp')
    use('L3MON4D3/LuaSnip')
    use({
      'saadparwaiz1/cmp_luasnip',
      requires = { 'hrsh7th/nvim-cmp', 'L3MON4D3/LuaSnip' },
    })
    use('rafamadriz/friendly-snippets')
    use('onsails/lspkind-nvim')
    -- }}}
    use('folke/lua-dev.nvim')
    use({ 'fatih/vim-go', ft = { 'go', 'gomod' } })
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
  end,
  config = {
    display = {
      open_fn = function()
        return require('packer.util').float({ border = 'single' })
      end,
    },
  },
})

require('config/settings')
require('config/mappings')
require('config/theme')
