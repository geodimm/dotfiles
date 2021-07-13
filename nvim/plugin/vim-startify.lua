vim.g.startify_session_autoload = 1
vim.g.startify_change_to_vcs_root = 1
vim.g.startify_fortune_use_unicode = 1
vim.g.startify_session_persistence = 1
vim.g.startify_enable_special = 1

vim.g.startify_lists = {
    {type = 'sessions', header = {'   Sessions'}},
    {type = 'files', header = {'   Files'}},
    {
        type = 'dir',
        header = {'   Current Directory (' .. vim.fn.getcwd() .. ')'}
    }, {type = 'bookmarks', header = {'   Bookmarks'}}
}

vim.g.startify_bookmarks = {
    {ev = '~/dotfiles/nvim/init.lua'}, {et = '~/dotfiles/tmux/tmux.conf'},
    {ez = '~/dotfiles/zsh/zshrc'}, {ep = '~/dotfiles/zsh/p10k.zsh'}
}

vim.api.nvim_set_keymap('n', '<leader>p', ':Startify<CR>', {noremap = true})

vim.g.startify_session_before_save = {'silent! NvimTreeClose'}
