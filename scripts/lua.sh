#!/usr/bin/env bash

set -e

source "$(pwd)/scripts/util.sh"

do_install() {
    if is_installed lua; then
        info "[lua] Already installed"
        return
    fi

    info "Installing lua"
    sudo apt install -y luarocks
}

do_configure() {
    info "[lua] Configure"
    info "[lua][configure] Install modules"
    sudo luarocks install --server=http://luarocks.org/dev lua-lsp
    sudo luarocks install luacheck
    sudo luarocks install Formatter
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

