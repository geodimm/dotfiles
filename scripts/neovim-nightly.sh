#!/usr/bin/env bash

set -e

source "$(pwd)/scripts/util.sh"

do_install() {
    info "[neovim-nightly] Install"
    asset=$(curl --silent https://api.github.com/repos/neovim/neovim/releases/tags/nightly | jq -r '.assets[] | select(.name | endswith("nvim.appimage")) | .url')
    mkdir -p ~/bin
    curl --silent --location -H "Accept: application/octet-stream" "${asset}" > ~/bin/nvim
    chmod +x ~/bin/nvim
}

do_configure() {
    info "[neovim-nightly] Configure"
    info "[neovim-nightly][configure] Create symlinks"
    ln -sf ~/bin/nvim ~/bin/vi
    ln -sf ~/bin/nvim ~/bin/vim
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
