#!/usr/bin/env bash

set -e

# shellcheck source=../scripts/util.sh
source "$(pwd)/scripts/util.sh"

do_configure() {
	info "[tmux] Configure"
	info "[tmux][configure] Download tpm plugin manager"
	if [[ ! -d "${HOME}/.tmux/plugins/tpm" ]]; then
		git clone --quiet https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
	fi

	info "[tmux][configure] Create config file symlink"
	ln -fs "$(pwd)/tmux/tmux.conf" "${HOME}/.tmux.conf"
}

main() {
	command=$1
	case $command in
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
