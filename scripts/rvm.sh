#!/usr/bin/env bash

set -e

source "$(pwd)/scripts/util.sh"

RVM_DIR="${HOME}/.rvm"

do_install() {
    if [[ -f "${RVM_DIR}/scripts/rvm" ]]; then
        info "[rvm] Already installed"
        return
    fi

    info "[rvm] Install"
    gpg --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    curl -sSL https://get.rvm.io | bash -s stable
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
