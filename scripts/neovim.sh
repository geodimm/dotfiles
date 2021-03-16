#!/usr/bin/env bash

set -e

source "$(pwd)/scripts/util.sh"

RVM_DIR="${HOME}/.rvm"
NVM_DIR="${HOME}/.nvm"

do_install() {
    if is_installed nvim; then
        info "[neovim] Already installed"
        return
    fi

    info "[neovim] Install"
    sudo add-apt-repository ppa:neovim-ppa/unstable -y
    sudo apt update
    sudo apt install -y neovim
}

do_configure() {
    info "[neovim] Configure"
    info "[neovim][configure] Set as default editor"
    local nvim_path
    nvim_path="$(type -P nvim)"
    sudo update-alternatives --install /usr/bin/vi vi "$nvim_path" 60
    sudo update-alternatives --set vi "$nvim_path"
    sudo update-alternatives --install /usr/bin/vim vim "$nvim_path" 60
    sudo update-alternatives --set vim "$nvim_path"
    sudo update-alternatives --install /usr/bin/editor editor "$nvim_path" 60
    sudo update-alternatives --set editor "$nvim_path"

    info "[neovim][configure] Install the neovim package for languages"
    python3 -m pip install neovim --user
    python3 -m pip install neovim-remote --user
    source "${RVM_DIR}/scripts/rvm" && gem install neovim
    source "${NVM_DIR}/nvm.sh" && npm install -g neovim

    info "[neovim][configure] Create symlinks"
    rm -f "${XDG_CONFIG_HOME}/nvim"
    ln -fs "$(pwd)/nvim" "${XDG_CONFIG_HOME}/nvim"

    info "[neovim][configure] Install vim-plug plugin manager"
    local vimplug="$(pwd)/nvim/autoload/plug.vim"
    download_to "${vimplug}" https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    info "[neovim][configure] Install plugins"
    nvim --headless +PlugInstall +qall
}

main() {
    command=$1
    case $command in
        "install")
            shift
            do_install "$@"
            ;;
        "configure")
            shift
            do_configure "$@"
            ;;
        *)
            error "$(basename "$0"): '$command' is not a valid command"
            ;;
    esac
}

main "$@"
