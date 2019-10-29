#!/usr/bin/env bash

XDG_CONFIG_HOME="${HOME}/.config"

ZSH="${HOME}/.oh-my-zsh"
ZSH_CUSTOM="${ZSH}/custom"

BAT_VERSION="${BAT_VERSION:=0.11.0}"

NVM="${HOME}/.nvm"
NVM_VERSION="${NVM_VERSION:=0.34.0}"

GO_VERSION="${GO_VERSION:=1.12.7}"

set -e

packages=(
    curl
    htop
    httpie
    jq
    ncurses-term
    python2-dev
    python2-pip
    python3-dev
    python3-pip
    tig
    tmux
    xclip
    zsh
)

function install_packages () {
    sudo apt install -y "${packages[@]}"
}

function install_neovim () {
    sudo add-apt-repository ppa:neovim-ppa/unstable
    sudo apt update
    sudo apt install -y neovim
}

function install_oh_my_zsh () {
    test -d ${ZSH} && return
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
}

function install_bat () {
    curl -fLo /tmp/bat${BAT_VERSION}.deb "https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat_${BAT_VERSION}_amd64.deb"
    sudo dpkg -i /tmp/bat${BAT_VERSION}.deb
}

function install_nvm () {
    mkdir -p ${NVM}
    curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh" | bash
}

function install_node () {
    test -f "${NVM_DIR}/nvm.sh" && source "${NVM_DIR}/nvm.sh"
    nvm install node
}

function install_go () {
    curl -fLo /tmp/go${GO_VERSION}.tar.gz "https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz"
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf /tmp/go${GO_VERSION}.tar.gz
}

function install_deps () {
    install_packages
    install_oh_my_zsh
    install_neovim
    install_bat
    install_go
    install_nvm
    install_node
}

function configure_tmux () {
    mkdir -p ${HOME}/.tmux/themes
    git clone https://github.com/srcery-colors/srcery-tmux/ ${HOME}/.tmux/themes/srcery-tmux || true
    ln -fs "$(pwd)/tmux/tmux.conf" "${HOME}/.tmux.conf"
    ln -fs "$(pwd)/tmux/tnew.sh" "${HOME}/tnew.sh"
}

function configure_zsh () {
    sudo chsh -s $(which zsh)
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" || true
    git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" || true
    git clone https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM}/themes/powerlevel10k" || true
    ln -fs "$(pwd)/zsh/zshrc" ${HOME}/.zshrc
    ln -fs "$(pwd)/zsh/zshenv" ${HOME}/.zshenv
    ln -fs "$(pwd)/zsh/aliases.zsh" "${ZSH_CUSTOM}/aliases.zsh"
    ln -fs "$(pwd)/zsh/p10k.zsh" "${ZSH_CUSTOM}/p10k.zsh"
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
    rm -f "${XDG_CONFIG_HOME}/nvim"
    ln -fs "$(pwd)/nvim" "${XDG_CONFIG_HOME}/nvim"
    curl -fLo "$(pwd)/nvim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    nvim +PlugInstall +qall

    # install coc-settings deps
    # bash-language-server fails under 12.4.0, use 11.14.0
    # nvm install 11.14.0 && nvm use 11.14.0
    npm i -g bash-language-server
    npm i -g dockerfile-language-server-nodejs
}

function configure () {
    configure_git
    configure_tmux
    configure_zsh
    configure_nvim
}

install_deps
configure
