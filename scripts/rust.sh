#!/usr/bin/env bash

set -e

DOTFILES_DIR="${DOTFILES_DIR:=${PWD}}"
# shellcheck disable=SC1090
source "${DOTFILES_DIR}/scripts/util.sh"

function do_install() {
	if is_installed rustc; then
		info "[rust] Already installed"
		return
	fi

	info "[rust] Install"
	curl --silent --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
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
