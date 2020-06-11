#!/usr/bin/env bash

XDG_CONFIG_HOME="${HOME}/.config"

ZSH="${HOME}/.oh-my-zsh"
ZSH_CUSTOM="${ZSH}/custom"

BAT_VERSION="${BAT_VERSION:=0.15.4}"

NVM_DIR="${HOME}/.nvm"
NVM_VERSION="${NVM_VERSION:=0.34.0}"

RVM_DIR="${HOME}/.rvm"
RUBY_VERSION=2.6

FZF_DIR="${HOME}/.fzf"

GO_VERSION="${GO_VERSION:=1.14.3}"

set -e

packages=(
    cmake
    curl
    universal-ctags
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
    type -P "$1" > /dev/null 2>&1
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
    test -d "${ZSH}" && return
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
}

function install_fzf () {
    test -d "${FZF_DIR}" && return
    git clone --depth 1 https://github.com/junegunn/fzf.git "${FZF_DIR}"
    "${FZF_DIR}/install"
}

function install_bat () {
    is_installed bat && return
    curl -fLo "/tmp/bat${BAT_VERSION}.deb" "https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat_${BAT_VERSION}_amd64.deb"
    sudo dpkg -i "/tmp/bat${BAT_VERSION}.deb"
}

function install_colorls () {
    is_installed colorls && return
    gem install colorls
}

function install_nvm () {
    test -f "${NVM_DIR}/nvm.sh" && return
    mkdir -p "${NVM_DIR}"
    curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh" | bash
}

function install_node {
    is_installed node && return
    nvm install node
}

function install_rvm () {
    test -f "${RVM_DIR}/scripts/rvm" && return
    gpg --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    curl -sSL https://get.rvm.io | bash -s stable
}

function install_ruby {
    [[ "$(rvm list | grep ${RUBY_VERSION})" != "" ]] && return
    rvm install "${RUBY_VERSION}"
}

function install_go () {
    if [[ "$(go version)" == *"${GO_VERSION}"* ]]; then return; fi
    curl -fLo "/tmp/go${GO_VERSION}.tar.gz" "https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz"
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf "/tmp/go${GO_VERSION}.tar.gz"
}

function install_deps () {
    install_packages
    install_oh_my_zsh
    install_neovim
    install_fzf
    install_bat
    install_rvm
    install_ruby
    install_colorls
    install_go
    install_nvm
    install_node
}

function configure_colorls () {
    mkdir -p "${XDG_CONFIG_HOME}/colorls"
    ln -fs "$(pwd)/colorls/dark_colors.yaml" "${XDG_CONFIG_HOME}/colorls/dark_colors.yaml"
}

function configure_tmux () {
    mkdir -p "${HOME}/.tmux/themes"
    git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
    ln -fs "$(pwd)/tmux/tmux.conf" "${HOME}/.tmux.conf"
    ln -fs "$(pwd)/tmux/tnew.sh" "${HOME}/tnew.sh"
}

function configure_lua () {
    sudo luarocks install --server=http://luarocks.org/dev lua-lsp
    sudo luarocks install luacheck
    sudo luarocks install Formatter
}

function configure_zsh () {
    chsh -s "$(type -P zsh)"
    git clone https://github.com/zdharma/fast-syntax-highlighting.git "${ZSH_CUSTOM}/plugins/fast-syntax-highlighting" || true
    git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" || true
    git clone https://github.com/zsh-users/zsh-completions "${ZSH_CUSTOM}/plugins/zsh-completions" || true
    git clone https://github.com/Aloxaf/fzf-tab "${ZSH_CUSTOM}/plugins/fzf-tab" || true
    git clone https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM}/themes/powerlevel10k" || true
    ln -fs "$(pwd)/zsh/p10k.zsh" "${ZSH_CUSTOM}/p10k.zsh"
    ln -fs "$(pwd)/zsh/aliases.zsh" "${ZSH_CUSTOM}/aliases.zsh"
    ln -fs "$(pwd)/zsh/zshrc" "${HOME}/.zshrc"
    ln -fs "$(pwd)/zsh/zshenv" "${HOME}/.zshenv"
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
    local nvim_path
    nvim_path="$(type -P nvim)"
    sudo update-alternatives --install /usr/bin/vi vi "$nvim_path" 60
    sudo update-alternatives --set vi "$nvim_path"
    sudo update-alternatives --install /usr/bin/vim vim "$nvim_path" 60
    sudo update-alternatives --set vim "$nvim_path"
    sudo update-alternatives --install /usr/bin/editor editor "$nvim_path" 60
    sudo update-alternatives --set editor "$nvim_path"

    # setup configuration files
    rm -f "${XDG_CONFIG_HOME}/nvim"
    ln -fs "$(pwd)/nvim" "${XDG_CONFIG_HOME}/nvim"
    curl -fLo "$(pwd)/nvim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    nvim +PlugInstall +qall
    nvim +"silent CocInstall -sync coc-explorer coc-floaterm coc-git coc-go coc-python coc-java coc-sh coc-lua coc-vimlsp coc-json coc-yaml coc-html coc-xml coc-css coc-docker coc-marketplace coc-pairs coc-yank coc-snippets coc-markdownlint coc-emoji coc-swagger coc-actions" +qall
}

function configure () {
    configure_colorls
    configure_git
    configure_tmux
    configure_zsh
    configure_nvim
    configure_lua
}

install_deps
configure
