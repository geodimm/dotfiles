#!/usr/bin/env bash

set -e

source "$(pwd)/scripts/util.sh"

TIG_VERSION="${TIG_VERSION:=master}"

do_install() {
    if is_installed tig; then
        info "[tig] Already installed"
        return
    fi

    local install_dir="/tmp/tig"

    info "[tig] Install"
    sudo rm -rf "$install_dir" && mkdir -p "$install_dir"
    git clone --branch "${TIG_VERSION}" https://github.com/jonas/tig.git "$install_dir"
    make -C "$install_dir" configure
    (cd "$install_dir" && ./configure)
    make -C "$install_dir"
    sudo make -C "$install_dir" install
}

do_configure() {
    info "[tig] Configure"
    info "[tig][configure] Create symlinks"
    ln -fs "$(pwd)/tig/tigrc" "${HOME}/.tigrc"
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
