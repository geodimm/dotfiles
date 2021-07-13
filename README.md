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

* [onedark] A dark Vim/Neovim color scheme inspired by Atom's One Dark syntax theme.
* [ohmyzsh] Oh My Zsh is an open source, community-driven
framework for managing your zsh configuration.
* [powerlevel10k] Powerlevel10k is a theme for Zsh. It emphasizes speed,
flexibility and out-of-the-box experience.
* [fzf] A command-line fuzzy finder
protocol support as VSCode
* [bat] A cat(1) clone with wings.
* [colorls] A Ruby gem that beautifies the terminal's ls command,

## Screenshots

### Tmux

The tmux status is centered and has colour coded indicators for:

* client prefix ![colour012](https://via.placeholder.com/15/0000FF?text=+)
`colour012 (Blue)`
* copy mode ![colour003](https://via.placeholder.com/15/FFFF00?text=+)
`colour003 (Yellow)`
* zoomed panes ![colour002](https://via.placeholder.com/15/00FF00?text=+)
`colour002 (Green)`
* synchronized panes ![colour001](https://via.placeholder.com/15/FF0000?text=+)
`colour001 (Red)`

![Tmux status bar](screenshots/tmux-status-bar.png)

### Shell

#### List directory contents and show git status for each entry with [colorls]

![Colorls](screenshots/colors-with-git-status.png)

#### Command history search with [fzf]

![FZF Ctrl+R](screenshots/fzf-ctrl-r.png)

#### Autocompletion file preview with [fzf] and [bat]

![FZF File Preview](screenshots/fzf-tab-file-preview.png)

#### Autocompletion directory preview with [fzf] and [colorls]

![FZF Directory Preview](screenshots/fzf-tab-directory-preview.png)

#### Neovim

#### Session management with [vim-startify]

![VIM Startify](screenshots/vim-startify.png)

#### LSP symbols and tags with [fzf.vim] and [vista.vim]

![VIM Vista](screenshots/vim-vista.png)

#### Terminal with [vim-floaterm]

![VIM Floaterm](screenshots/vim-floaterm.png)

### And much more

[bat]: https://github.com/sharkdp/bat "Bat"
[colorls]: https://github.com/athityakumar/colorls "Colorls"
[fzf.vim]: https://github.com/junegunn/fzf.vim "FZF Vim"
[fzf]: https://github.com/junegunn/fzf "FZF"
[onedark]: https://github.com/navarasu/onedark.nvim "OneDark"
[ohmyzsh]: https://github.com/ohmyzsh/ohmyzsh "Oh My Zsh"
[powerlevel10k]: https://github.com/romkatv/powerlevel10k "Powerlevel10k"
[vim-floaterm]: https://github.com/voldikss/vim-floaterm "VIM Floaterm"
[vim-startify]: https://github.com/mhinz/vim-startify "VIM Startify"
[vista.vim]: https://github.com/liuchengxu/vista.vim "Vista Vim"
