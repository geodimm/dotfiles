call plug#begin('~/dotfiles/nvim/autoload/plugged')

Plug 'mhinz/vim-startify'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'psliwka/vim-smoothie'
Plug 'morhetz/gruvbox'
Plug 'sheerun/vim-polyglot'
Plug 'ryanoasis/vim-devicons'
Plug 'mbbill/undotree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'antoinemadec/coc-fzf'
Plug 'tmux-plugins/vim-tmux'
Plug 'urbainvaes/vim-tmux-pilot'
Plug 'voldikss/vim-floaterm'
Plug 'liuchengxu/vista.vim'
Plug 'wellle/targets.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'unblevable/quick-scope'
Plug 'rhysd/git-messenger.vim'
Plug 'fatih/vim-go', {'for': ['go', 'gomod']}
Plug 'sebdah/vim-delve', {'for': 'go'}
Plug 'hashivim/vim-terraform'
Plug 'uiiaoo/java-syntax.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'pechorin/any-jump.vim'
Plug 'liuchengxu/vim-which-key'
Plug 'brooth/far.vim'

call plug#end()
