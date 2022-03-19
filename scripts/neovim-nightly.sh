#!/usr/bin/env bash

set -e

# shellcheck source=../scripts/util.sh
source "$(pwd)/scripts/util.sh"

do_install() {
	info "[neovim-nightly] Install"
	local nvim_path="${HOME}/bin/nvim"
	asset=$(curl --silent https://api.github.com/repos/neovim/neovim/releases/tags/nightly | jq -r '.assets // [] | .[] | select(.name | endswith("nvim.appimage")) | .url')
	if [[ -z ${asset} ]]; then
		warn "Cannot find a nightly release. Please try again later."
		exit 0
	fi
	download "${asset}" "${nvim_path}"
	chmod +x "${nvim_path}"

	info "[neovim-nightly][install] Create symlinks to override the stable version"
	ln -sf "${nvim_path}" "${HOME}/bin/vi"
	ln -sf "${nvim_path}" "${HOME}/bin/vim"
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
