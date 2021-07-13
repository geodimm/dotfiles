-- vim: foldmethod=marker
local install_path = vim.fn.stdpath('data') ..
                         '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.api.nvim_command(
        '!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

vim.api.nvim_exec([[
augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
augroup end
]], false)

local use = require('packer').use
require('packer').startup({
    function()
        -- Vanity {{{
        use 'wbthomason/packer.nvim'
        use 'mhinz/vim-startify'
        use 'akinsho/nvim-bufferline.lua'
        use 'hoob3rt/lualine.nvim'
        use 'gruvbox-community/gruvbox'
        use 'arcticicestudio/nord-vim'
        use 'navarasu/onedark.nvim'
        use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
        use 'kyazdani42/nvim-web-devicons'
        use {'RRethy/vim-hexokinase', run = 'make hexokinase'}
        -- }}}

        -- IDE-like features {{{
        use 'kyazdani42/nvim-tree.lua'
        use 'voldikss/vim-floaterm'
        use 'rhysd/git-messenger.vim'
        use 'tpope/vim-fugitive'
        use 'folke/which-key.nvim'
        use {'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'}}

        use {
            'windwp/nvim-spectre',
            requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
        }
        use {
            'nvim-telescope/telescope.nvim',
            requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
        }
        use {
            'nvim-telescope/telescope-fzy-native.nvim',
            requires = {'nvim-telescope/telescope.nvim'}
        }
        use {
            'gbrlsnchs/telescope-lsp-handlers.nvim',
            requires = {'nvim-telescope/telescope.nvim'}
        }
        use 'kosayoda/nvim-lightbulb'
        -- }}}

        -- Tmux integration {{{
        use 'tmux-plugins/vim-tmux'
        use 'urbainvaes/vim-tmux-pilot'
        -- }}}

        -- Text editing features {{{
        use 'mbbill/undotree'
        use 'wellle/targets.vim'
        use 'tpope/vim-surround'
        use 'tpope/vim-commentary'
        use 'tpope/vim-repeat'
        -- }}}

        -- " Languages/LSP {{{
        use {'neovim/nvim-lspconfig'}
        use {'kabouzeid/nvim-lspinstall'}
        use {'hrsh7th/nvim-compe'}
        use {'fatih/vim-go', ft = {'go', 'gomod'}}
        use {'andrejlevkovitch/vim-lua-format', ft = {'lua'}}
        use 'hashivim/vim-terraform'
        use 'godlygeek/tabular' -- required to format Markdown tables
        use {
            'iamcco/markdown-preview.nvim',
            run = function() vim.fn['mkdp#util#install']() end
        }
        -- }}}
    end,
    config = {
        display = {
            open_fn = function()
                return require('packer.util').float({border = 'single'})
            end
        }
    }
})

require('config/settings')
require('config/mappings')
require('config/theme')
