#!/usr/bin/env bash

set -e

# shellcheck source=../scripts/util.sh
source "$(pwd)/scripts/util.sh"

NVM_DIR="${HOME}/.nvm"

do_install() {
	if is_installed node; then
		info "[node] Already installed"
		return
	fi

	info "[node] Install"
	# shellcheck source=../../.nvm/nvm.sh
	source "${NVM_DIR}/nvm.sh" && nvm install node
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
