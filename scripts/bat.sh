#!/usr/bin/env bash

set -e

source "$(pwd)/scripts/util.sh"

BAT_VERSION="${BAT_VERSION:=0.15.4}"

do_install() {
    if is_installed bat; then
        info "[bat] ${BAT_VERSION} already installed"
        return
    fi

    info "[bat] Install ${BAT_VERSION}"
    local bat=/tmp/bat.deb
    download_to "${bat}" "https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat_${BAT_VERSION}_amd64.deb"
    sudo dpkg -i "${bat}"
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
