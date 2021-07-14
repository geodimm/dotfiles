#!/usr/bin/env bash

set -e

# shellcheck source=../scripts/util.sh
source "$(pwd)/scripts/util.sh"

do_install() {
	if is_installed tig; then
		info "[tig] Already installed"
		return
	fi

	info "[tig] Install"
	sudo apt install -y tig
}

do_configure() {
	info "[tig] Configure"
	info "[tig][configure] Create symlinks"
	ln -fs "$(pwd)/tig/tigrc" "${HOME}/.tigrc"
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
