# Georgi's dotfiles

[![Build Status](https://img.shields.io/travis/com/georgijd/dotfiles.svg?style=for-the-badge&logo=travis)](https://travis-ci.com/georgijd/dotfiles)

## How to install

 :exclamation: **Warning:** If you want to give these dotfiles a try, you
 should first fork this repository, review the code, and remove things you
 don’t want or need. Don’t blindly use my settings unless you know what that
 entails. Use at your own risk!

> For more information run `make help`

```bash
git clone https://github.com/georgijd/dotfiles.git ~/dotfiles
cd ~/dotfiles
make
```

## Useful Links

* [gruvbox] Retro groove color scheme for Vim.
* [ohmyzsh] Oh My Zsh is an open source, community-driven
framework for managing your zsh configuration.
* [powerlevel10k] Powerlevel10k is a theme for Zsh. It emphasizes speed,
flexibility and out-of-the-box experience.
* [fzf] A command-line fuzzy finder
* [coc.nvim] Intellisense engine for Vim8 & Neovim, full language server
protocol support as VSCode
* [bat] A cat(1) clone with wings.
* [colorls] A Ruby gem that beautifies the terminal's ls command,

## Screenshots

### Tmux

The tmux status is centered with colour coded indicators for:

* client prefix ![#83a598](https://via.placeholder.com/15/83a598?text=+) `#83a598`
* copy mode ![#fabd2f](https://via.placeholder.com/15/fabd2f?text=+) `#fabd2f`
* zoomed panes ![#b8bb26](https://via.placeholder.com/15/b8bb26?text=+) `#b8bb26`
* synchronized panes ![#fb4934](https://via.placeholder.com/15/fb4934?text=+) `#fb4934`

![Tmux status bar](screenshots/tmux-status-bar.png)

### Shell

#### List directory contents with [colorls] including git status

![Colorls](screenshots/colors-with-git-status.png)

#### Command history search with [fzf]

![FZF Ctrl+R](screenshots/fzf-ctrl-r.png)

#### Autocompletion file preview [fzf] and [bat]

![FZF File Preview](screenshots/fzf-tab-file-preview.png)

#### Autocompletion directory preview [fzf] and [colorls]

![FZF Directory Preview](screenshots/fzf-tab-directory-preview.png)

#### Neovim

#### Session management with [vim-startify]

![VIM Startify](screenshots/vim-startify.png)

#### LSP diagnostics with [coc.nvim]

![VIM LSP Diagnostics](screenshots/vim-cocnvim-diagnostics.png)

#### Autocompletion with [coc.nvim]

![VIM LSP Autocompletion](screenshots/vim-cocnvim-autocompletion-with-docs.png)

#### Symbol Documentation with [coc.nvim]

![VIM LSP Documentation](screenshots/vim-cocnvim-hover-doc.png)

#### LSP symbols and tags with [fzf.vim] and [vista.vim]

![VIM Vista](screenshots/vim-vista.png)

#### File explorer with [coc.nvim] and [coc-explorer]

![VIM Coc Explorer](screenshots/vim-coc-explorer.png)

#### Terminal with [vim-floaterm]

![VIM Floaterm](screenshots/vim-floaterm.png)

#### File fuzzy search with [fzf.vim]

![VIM FZF Files](screenshots/vim-fzf-files.png)

#### Git grep with [fzf.vim]

![VIM FZF Git Grep](screenshots/vim-fzf-git-grep.png)

### And much more

[bat]: https://github.com/sharkdp/bat "Bat"
[coc-explorer]: https://github.com/weirongxu/coc-explorer "Coc Explorer"
[coc.nvim]: https://github.com/neoclide/coc.nvim "Conquer of Completion"
[colorls]: https://github.com/athityakumar/colorls "Colorls"
[fzf.vim]: https://github.com/junegunn/fzf.vim "FZF Vim"
[fzf]: https://github.com/junegunn/fzf "FZF"
[gruvbox]: https://github.com/morhetz/gruvbox "Gruvbox"
[ohmyzsh]: https://github.com/ohmyzsh/ohmyzsh "Oh My Zsh"
[powerlevel10k]: https://github.com/romkatv/powerlevel10k "Powerlevel10k"
[tmux-copycat]: https://github.com/tmux-plugins/tmux-copycat "Tmux copycat"
[tmux-open]: https://github.com/tmux-plugins/tmux-open "Tmux open"
[tmux-sensible]: https://github.com/tmux-plugins/tmux-sensible "Tmux sensible"
[tmux-yank]: https://github.com/tmux-plugins/tmux-yank "Tmux yank"
[tpm]: https://github.com/tmux-plugins/tpm "Tmux Plugin Manager"
[vim-floaterm]: https://github.com/voldikss/vim-floaterm "VIM Floaterm"
[vim-startify]: https://github.com/mhinz/vim-startify "VIM Startify"
[vista.vim]: https://github.com/liuchengxu/vista.vim "Vista Vim"
