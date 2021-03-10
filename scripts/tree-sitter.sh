#!/usr/bin/env bash

set -e

source "$(pwd)/scripts/util.sh"

NVM_DIR="${HOME}/.nvm"

do_install() {
    if is_installed tree-sitter; then
        info "[tree-sitter] Already installed"
        return
    fi

    info "[tree-sitter] Install"
    source "${NVM_DIR}/nvm.sh" && npm install -g tree-sitter-cli
}

main() {
    command=$1
    case $command in
        "install")
            shift
            do_install "$@"
            ;;
        *)
            error "$(basename "$0"): '$command' is not a valid command"
            ;;
    esac
}

main "$@"
