#!/usr/bin/env bash

set -e

source "$(pwd)/scripts/util.sh"

do_install() {
    if is_installed tree-sitter; then
        info "[tree-sitter] Already installed"
        return
    fi

    info "[tree-sitter] Install"
    asset=$(curl --silent https://api.github.com/repos/tree-sitter/tree-sitter/releases/latest | jq -r '.assets[] | select(.name | contains("linux")) | .url')
    mkdir -p ~/bin
    curl --silent --location -H "Accept: application/octet-stream" "${asset}" | gunzip -c > ~/bin/tree-sitter
    chmod +x ~/bin/tree-sitter
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
