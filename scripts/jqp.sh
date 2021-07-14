#!/usr/bin/env bash

set -e

# shellcheck source=../scripts/util.sh
source "$(pwd)/scripts/util.sh"

do_install() {
	if is_installed jqp; then
		info "[jqp] Already installed"
		return
	fi

	info "[jqp] Install"
	curl -s "https://raw.githubusercontent.com/georgijd/jqp/main/scripts/install.sh" | bash
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
