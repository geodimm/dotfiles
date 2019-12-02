#!/usr/bin/env bash

XDG_CONFIG_HOME="${HOME}/.config"

ZSH="${HOME}/.oh-my-zsh"
ZSH_CUSTOM="${ZSH}/custom"

BAT_VERSION="${BAT_VERSION:=0.11.0}"

NVM="${HOME}/.nvm"
NVM_VERSION="${NVM_VERSION:=0.34.0}"

GO_VERSION="${GO_VERSION:=1.13.4}"

set -e

packages=(
    curl
    exuberant-ctags
    htop
    httpie
    jq
    luarocks
    ncurses-term
    python-dev
    python-pip
    python3-dev
    python3-pip
    tig
    tmux
    tree
    units
    xclip
    zsh
)

function is_installed() {
    which $1 > /dev/null 2>&1
}

function install_packages () {
    sudo apt update
    sudo apt install -y "${packages[@]}"
}

function install_neovim () {
    is_installed nvim && return
    sudo add-apt-repository ppa:neovim-ppa/unstable
    sudo apt update
    sudo apt install -y neovim
}

function install_oh_my_zsh () {
    test -d ${ZSH} && return
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
}

function install_bat () {
    is_installed bat && return
    curl -fLo /tmp/bat${BAT_VERSION}.deb "https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat_${BAT_VERSION}_amd64.deb"
    sudo dpkg -i /tmp/bat${BAT_VERSION}.deb
}

function install_nvm () {
    test -f "${NVM}/nvm.sh" return
    mkdir -p ${NVM}
    curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh" | bash
}

function install_node () {
    is_installed node && return
    test -f "${NVM}/nvm.sh" && source "${NVM}/nvm.sh"
    nvm install node
}

function install_go () {
    if [[ "$(go version)" == *"${GO_VERSION}"* ]]; then return; fi
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
    chsh -s $(which zsh)
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
    local nvim_path="$(which nvim)"
    sudo update-alternatives --install /usr/bin/vi vi $nvim_path 60
    sudo update-alternatives --set vi $nvim_path
    sudo update-alternatives --install /usr/bin/vim vim $nvim_path 60
    sudo update-alternatives --set vim $nvim_path
    sudo update-alternatives --install /usr/bin/editor editor $nvim_path 60
    sudo update-alternatives --set editor $nvim_path

    # setup configuration files
    rm -f "${XDG_CONFIG_HOME}/nvim"
    ln -fs "$(pwd)/nvim" "${XDG_CONFIG_HOME}/nvim"
    curl -fLo "$(pwd)/nvim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    nvim +PlugInstall +qall

    # CocInstall coc-explorer coc-go coc-python coc-java coc-json coc-yaml coc-html coc-css coc-lua coc-vimlsp

    # install coc-settings deps
    npm i -g bash-language-server
    npm i -g dockerfile-language-server-nodejs
    sudo luarocks install --server=http://luarocks.org/dev lua-lsp
    sudo luarocks install luacheck
    sudo luarocks install Formatter
}

function configure () {
    configure_git
    configure_tmux
    configure_zsh
    configure_nvim
}

install_deps
configure
