let g:startify_session_autoload = 1
let g:startify_change_to_vcs_root = 1
let g:startify_fortune_use_unicode = 1
let g:startify_session_persistence = 1
let g:startify_enable_special = 0

let g:startify_lists = [
    \ { 'type': 'sessions',  'header': ['   Sessions'] },
    \ { 'type': 'files',     'header': ['   Files'] },
    \ { 'type': 'dir',       'header': ['   Current Directory ('. getcwd() .')'] },
    \ { 'type': 'bookmarks', 'header': ['   Bookmarks'] },
    \ ]

let g:startify_bookmarks = [
    \ { 'ev': '~/dotfiles/nvim/init.vim' },
    \ { 'ec': '~/dotfiles/nvim/coc-settings.json' },
    \ { 'et': '~/dotfiles/tmux/tmux.conf' },
    \ { 'ez': '~/dotfiles/zsh/zshrc' },
    \ ]

highlight link StartifyPath GruvboxBlue
highlight link StartifySlash GruvboxBlue
highlight link StartifyFile GruvboxAquaBold
highlight link StartifyNumber GruvboxAquaBold
highlight link StartifySection GruvboxPurpleBold

nnoremap <leader>p :Startify<CR>