#!/usr/bin/env bash

set -e

source "$(pwd)/scripts/util.sh"

do_install() {
    if is_installed zsh; then
        info "[zsh] Already installed"
        return
    fi

    info "[zsh] Install"
    sudo apt install -y zsh
}

do_configure() {
    info "[zsh] Configure"
    info "[zsh][configure] Set as default shell"
    sudo usermod -s "$(type -P zsh)" "$(whoami)"
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
