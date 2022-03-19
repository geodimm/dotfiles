#!/usr/bin/env bash

set -e

# shellcheck source=../scripts/util.sh
source "$(pwd)/scripts/util.sh"

do_install() {
	info "[neovim-nightly] Install"
	asset=$(curl --silent https://api.github.com/repos/neovim/neovim/releases/tags/nightly | jq -r '.assets // [] | .[] | select(.name | endswith("nvim.appimage")) | .url')
	if [[ -z $asset ]]; then
		warn "Cannot find a nightly release. Please try again later."
		exit 0
	fi
	curl --silent --location -H "Accept: application/octet-stream" "${asset}" >~/bin/nvim
	chmod +x ~/bin/nvim

	info "[neovim-nightly][install] Create symlinks to override the stable version"
	ln -sf ~/bin/nvim ~/bin/vi
	ln -sf ~/bin/nvim ~/bin/vim
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
