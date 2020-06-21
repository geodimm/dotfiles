#!/usr/bin/env bash

set -e

source "$(pwd)/scripts/util.sh"

do_install() {
    if is_installed git; then
        info "[git] Already installed"
        return
    fi

    info "[git] Install"
    sudo apt install -y git
}

do_configure() {
    info "[git] Configure"
    info "[git][configure] Create symlinks"
    ln -fs "$(pwd)/git/gitconfig" "${HOME}/.gitconfig"
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
