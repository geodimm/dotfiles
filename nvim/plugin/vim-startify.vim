let g:startify_session_autoload = 1
let g:startify_change_to_vcs_root = 1
let g:startify_fortune_use_unicode = 1
let g:startify_session_persistence = 1
let g:startify_enable_special = 1

let g:startify_lists = [
    \ { 'type': 'sessions',  'header': ['   Sessions'] },
    \ { 'type': 'files',     'header': ['   Files'] },
    \ { 'type': 'dir',       'header': ['   Current Directory ('. getcwd() .')'] },
    \ { 'type': 'bookmarks', 'header': ['   Bookmarks'] },
    \ ]

let g:startify_bookmarks = [
    \ { 'ev': '~/dotfiles/nvim/lua/plugins.lua' },
    \ { 'ec': '~/dotfiles/nvim/coc-settings.json' },
    \ { 'et': '~/dotfiles/tmux/tmux.conf' },
    \ { 'ez': '~/dotfiles/zsh/zshrc' },
    \ { 'ep': '~/dotfiles/zsh/p10k.zsh' },
    \ ]

nnoremap <leader>p :Startify<CR>
