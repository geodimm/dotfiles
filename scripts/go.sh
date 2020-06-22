#!/usr/bin/env bash

set -e

source "$(pwd)/scripts/util.sh"

GO_VERSION="${GO_VERSION:=1.14.4}"

do_install() {
    if [[ "$(go version 2>/dev/null)" == *"${GO_VERSION}"* ]]; then
        info "[go] ${GO_VERSION} already installed"
        return
    fi

    info "[go] Install ${GO_VERSION}"
    local go="/tmp/go${GO_VERSION}.tar.gz" 
    download_to "${go}" "https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz"
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf "${go}"
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
