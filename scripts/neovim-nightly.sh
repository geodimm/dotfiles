#!/usr/bin/env bash

set -e

# shellcheck source=../scripts/util.sh
source "$(pwd)/scripts/util.sh"

do_install() {
	info "[neovim-nightly] Install"
	local target="/tmp/nvim.deb"
	asset=$(curl --silent https://api.github.com/repos/neovim/neovim/releases/tags/nightly | jq -r '.assets // [] | .[] | select(.name | endswith("nvim-linux64.deb")) | .url')
	if [[ -z ${asset} ]]; then
		warn "Cannot find a nightly release. Please try again later."
		exit 0
	fi
	download "${asset}" "${target}"
	sudo dpkg -i --force-overwrite "${target}"
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
