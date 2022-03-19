# Georgi's dotfiles

[![Build Status](https://github.com/georgijd/dotfiles/actions/workflows/test.yaml/badge.svg)](https://github.com/georgijd/dotfiles/actions/workflows/test.yaml)

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

- [ohmyzsh] Oh My Zsh is an open source, community-driven
framework for managing your zsh configuration.
- [powerlevel10k] Powerlevel10k is a theme for Zsh. It emphasizes speed,
-lexibility and out-of-the-box experience.
- [fzf] A command-line fuzzy finder
- [bat] A cat(1) clone with wings.
- [lsd] The next gen ls command

## Screenshots

### Tmux

The tmux status is centered and has colour coded indicators for:

- client prefix ![colour012](https://via.placeholder.com/15/0000FF?text=+)
`colour012 (Blue)`
- copy mode ![colour003](https://via.placeholder.com/15/FFFF00?text=+)
`colour003 (Yellow)`
- zoomed panes ![colour002](https://via.placeholder.com/15/00FF00?text=+)
`colour002 (Green)`
- synchronized panes ![colour001](https://via.placeholder.com/15/FF0000?text=+)
`colour001 (Red)`

![Tmux status bar](screenshots/tmux-status-bar.png)

### Shell

#### Command history search with [fzf]

![FZF Ctrl+R](screenshots/fzf-ctrl-r.png)

#### Autocompletion file preview with [fzf] and [bat]

![FZF File Preview](screenshots/fzf-tab-file-preview.png)

#### Autocompletion directory preview with [fzf] and [lsd]

![FZF Directory Preview](screenshots/fzf-tab-directory-preview.png)

#### Neovim

#### Session management with [vim-startify]

![VIM Startify](screenshots/vim-startify.png)

#### Terminal with [nvim-toggleterm.lua]

![NVIM Toggleterm](screenshots/vim-floaterm.png)

### And much more

[bat]: https://github.com/sharkdp/bat "Bat"
[lsd]: https://github.com/Peltoche/lsd "lsd"
[fzf.vim]: https://github.com/junegunn/fzf.vim "FZF Vim"
[fzf]: https://github.com/junegunn/fzf "FZF"
[ohmyzsh]: https://github.com/ohmyzsh/ohmyzsh "Oh My Zsh"
[powerlevel10k]: https://github.com/romkatv/powerlevel10k "Powerlevel10k"
[nvim-toggleterm.lua]: https://github.com/akinsho/nvim-toggleterm.lua "NVIM Toggleterm"
[vim-startify]: https://github.com/mhinz/vim-startify "VIM Startify"
