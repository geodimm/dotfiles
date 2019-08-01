# Georgi's dotfiles

## Installation

 :exclamation: **Warning:** If you want to give these dotfiles a try, you should first fork this repository, review the code, and remove things you don’t want or need. Don’t blindly use my settings unless you know what that entails. Use at your own risk!

:exclamation: **Warning**: Installing these dotfiles will replace the following files/ directories:

|| File
------------- | -------------
**i3**  | `$XDG_CONFIG_HOME/i3/config`
|| `$HOME/.i3status.conf`
**tmux**  | `$HOME/.tmux.conf`
|| `$HOME/.tmux/themes/srcery-tmux/`
**zsh**  | `$HOME/.zshrc`
|| `$HOME/.oh-my-zsh/custom/themes/oxide.zsh-theme`
|| `$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting`
|| `$HOME/.oh-my-zsh/plugins/zsh-autosuggestions`
**neovim**  | `$XDG_CONFIG_HOME/nvim`
**git**  | `$HOME/.gitconfig`
**tig**  | `$HOME/.tigrc`
**dunst**  | `$HOME/dunst/dunstrc`

> For more information refer to the [Makefile](./Makefile)

### Using Git
```bash
git clone https://github.com/georgijd/dotfiles.git ~/dotfiles && cd ~/dotfiles && make
```

### Git-free install
```bash
mkdir -p ~/dotfiles && curl -#L https://github.com/georgijd/dotfiles/tarball/master | tar -xzv -C ~/dotfiles --strip-components=1 && cd ~/dotfiles && make
```
