#!/usr/bin/env bash

set -e

DOTFILES_DIR="${DOTFILES_DIR:=${PWD}}"
# shellcheck disable=SC1090
source "${DOTFILES_DIR}/scripts/util.sh"

GO_VERSION="${GO_VERSION:=1.20}"

function do_install() {
	if [[ "$(go version 2>/dev/null)" == *"${GO_VERSION}"* ]]; then
		info "[go] ${GO_VERSION} already installed"
		return
	fi

	info "[go] Install ${GO_VERSION}"
	local go="/tmp/go${GO_VERSION}.tar.gz"
	local arch
	case "${PLATFORM}" in
	"linux")
		arch="amd64"
		;;
	"darwin")
		arch="arm64"
		;;
	esac
	download "https://dl.google.com/go/go${GO_VERSION}.${PLATFORM}-${arch}.tar.gz" "${go}"
	sudo rm -rf /usr/local/go
	sudo tar -C /usr/local -xzf "${go}"
}

function main() {
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
