#!/usr/bin/env bash

set -e

source "$(pwd)/scripts/util.sh"

TERMINAL=gnome-terminal

do_install() {
    info "[gnome-terminal-gruvbox] Install"
    local installer="/tmp/gogh.sh"
    download_to "${installer}" https://raw.githubusercontent.com/Mayccoll/Gogh/master/gogh.sh
    chmod +x "${installer}"
    echo "61 62" | TERMINAL="${TERMINAL}" bash -c "${installer}"
}

do_configure() {
    true
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
