#!/usr/bin/env bash

XDG_CONFIG_HOME="${HOME}/.config"
ZSH="${HOME}/.oh-my-zsh"
ZSH_CUSTOM="${ZSH}/custom"
BAT_VERSION="0.11.0"

set -e

packages=(
    curl
    htop
    httpie
    jq
    python2-dev
    python2-pip
    python3-dev
    python3-pip
    tig
    tmux
    zsh
)

function install_packages () {
    sudo apt install -y "${packages[@]}"
}

function install_neovim () {
    sudo add-apt-repository ppa:neovim-ppa/stable
    sudo apt update
    sudo apt install -y neovim
}

function install_oh_my_zsh () {
    test -d ~/.oh-my-zsh && return
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
}

function install_bat () {
    curl -fLo /tmp/bat.deb "https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat_${BAT_VERSION}_amd64.deb"
    sudo dpkg -i /tmp/bat.deb
    rm -f /tmp/bat.deb
}

function install_deps () {
    install_packages
    install_oh_my_zsh
    install_neovim
    install_bat
}

function configure_tmux () {
	mkdir -p ~/.tmux/themes
	git clone https://github.com/srcery-colors/srcery-tmux/ ~/.tmux/themes/srcery-tmux || true
    ln -fs "$(pwd)/tmux/tmux.conf" "${HOME}/.tmux.conf"
	ln -fs "$(pwd)/tmux/tnew.sh" "${HOME}/tnew.sh"
}

function configure_zsh () {
    sudo chsh -s $(which zsh)
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" || true
	git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" || true
	git clone https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM}/themes/powerlevel10k" || true
	ln -fs "$(pwd)/zsh/zshrc" ~/.zshrc
	ln -fs "$(pwd)/zsh/p10k.zsh" ~/.p10k.zsh
}

function configure_git () {
	ln -fs "$(pwd)/git/gitconfig" "${HOME}/.gitconfig"
	ln -fs "$(pwd)/tig/tigrc" "${HOME}/.tigrc"
}

function configure_nvim () {
    # install required python packages
    python2 -m pip install neovim --user
    python3 -m pip install neovim --user

    # set as a default editor
    sudo update-alternatives --set editor "$(which nvim)"

    # setup configuration files
	ln -fs "$(pwd)/vim" "${XDG_CONFIG_HOME}/nvim"
	ln -fs "$(pwd)/vim/vimrc" "${XDG_CONFIG_HOME}/nvim/init.vim"
	curl -fLo "$(pwd)/vim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	nvim +PlugInstall +qall
}

function configure () {
    configure_git
    configure_tmux
    configure_zsh
    configure_nvim
}

install_deps
configure
