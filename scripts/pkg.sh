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
        python-dev
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

    if ! is_installed pip2; then
        info "[pkg][install] Install python2-pip"
        local installer=/tmp/get-pip.py
        download_to "${installer}" https://bootstrap.pypa.io/get-pip.py
        sudo python2 "${installer}"
    fi
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
