#!/usr/bin/env bash

set -e

source "$(pwd)/scripts/util.sh"

DEBIAN_FRONTEND=noninteractive

do_install() {
    local packages=(
        cmake
        curl
        dconf-cli
        htop
        httpie
        jq
        moreutils
        ncurses-term
        python3-dev
        python3-pip
        tree
        units
        universal-ctags
        unrar
        uuid-runtime
        wget
        xclip
    )

    info "[pkg] Install"
    sudo apt update
    sudo apt install -y "${packages[@]}"
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
