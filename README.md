# Georgi's dotfiles

## Installation

 :exclamation: **Warning:** If you want to give these dotfiles a try, you should first fork this repository, review the code, and remove things you don’t want or need. Don’t blindly use my settings unless you know what that entails. Use at your own risk!

:exclamation: **Warning**: Installing these dotfiles will replace the following files/ directories:

|| File
------------- | -------------
**tmux**  | `$HOME/.tmux.conf`
**zsh**  | `$HOME/.zshrc`
|| `$HOME/.oh-my-zsh/custom/aliases.zsh`
|| `$HOME/.oh-my-zsh/custom/p10k.zsh`
|| `$HOME/.oh-my-zsh/plugins/zsh-autosuggestions`
|| `$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting`
**neovim**  | `$XDG_CONFIG_HOME/nvim`
**git**  | `$HOME/.gitconfig`
**tig**  | `$HOME/.tigrc`
**colorls**  | `$XDG_CONFIG_HOME/.colorls/dark_colors.yaml`

> For more information refer to the [install.sh](./install.sh)

### Using Git
```bash
git clone https://github.com/georgijd/dotfiles.git ~/dotfiles && cd ~/dotfiles && ./install.sh
```

### Git-free install
```bash
mkdir -p ~/dotfiles && curl -#L https://github.com/georgijd/dotfiles/tarball/master | tar -xzv -C ~/dotfiles --strip-components=1 && cd ~/dotfiles && ./install.sh
```
