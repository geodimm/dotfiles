" vim: foldmethod=marker
call plug#begin('~/dotfiles/nvim/autoload/plugged')

" Vanity {{{
Plug 'mhinz/vim-startify'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'gruvbox-community/gruvbox'
Plug 'arcticicestudio/nord-vim'
Plug 'joshdick/onedark.vim'
Plug 'sheerun/vim-polyglot'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'kyazdani42/nvim-web-devicons'
Plug 'RRethy/vim-hexokinase', { 'do': 'make hexokinase' }
" }}}

" IDE-like features {{{
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'voldikss/vim-floaterm'
Plug 'liuchengxu/vista.vim'
Plug 'pechorin/any-jump.vim'
Plug 'rhysd/git-messenger.vim'
Plug 'tpope/vim-fugitive'
Plug 'liuchengxu/vim-which-key'
" }}}

" Tmux integration {{{
Plug 'tmux-plugins/vim-tmux'
Plug 'urbainvaes/vim-tmux-pilot'
" }}}

" Text editing features {{{
Plug 'mbbill/undotree'
Plug 'wellle/targets.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
" }}}

" Languages/LSP {{{
Plug 'fatih/vim-go', {'for': ['go', 'gomod']}
Plug 'hashivim/vim-terraform'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'antoinemadec/coc-fzf', {'branch': 'release'}
Plug 'godlygeek/tabular'  " required to format Markdown tables
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
" }}}

call plug#end()
