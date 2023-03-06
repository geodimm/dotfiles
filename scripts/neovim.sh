#!/usr/bin/env bash

set -e

DOTFILES_DIR="${DOTFILES_DIR:=${PWD}}"
# shellcheck disable=SC1090
source "${DOTFILES_DIR}/scripts/util.sh"

NVM_DIR="${HOME}/.nvm"

function do_install() {
	info "[neovim] Install nightly"
	case "${PLATFORM}" in
	"linux")
		local target="/tmp/nvim.deb"
		asset=$(curl --silent https://api.github.com/repos/neovim/neovim/releases/tags/nightly | jq -r '.assets // [] | .[] | select(.name | endswith("nvim-linux64.deb")) | .url')
		if [[ -z ${asset} ]]; then
			warn "Cannot find a nightly release. Please try again later."
			exit 0
		fi
		download "${asset}" "${target}"
		sudo dpkg -i --force-overwrite "${target}"
		;;
	"darwin")
		if is_installed nvim; then
			brew upgrade neovim-nightly
		else
			brew tap austinliuigi/brew-neovim-nightly
			brew install neovim-nightly
		fi
		;;
	esac
}

function do_configure() {
	info "[neovim] Configure"
	info "[neovim][configure] Set as default editor"
	if [[ "${PLATFORM}" == "linux" ]]; then
		local nvim_path
		nvim_path="$(type -P nvim)"
		sudo update-alternatives --install /usr/bin/vi vi "$nvim_path" 60
		sudo update-alternatives --set vi "$nvim_path"
		sudo update-alternatives --install /usr/bin/vim vim "$nvim_path" 60
		sudo update-alternatives --set vim "$nvim_path"
		sudo update-alternatives --install /usr/bin/editor editor "$nvim_path" 60
		sudo update-alternatives --set editor "$nvim_path"
	fi

	info "[neovim][configure] Create configuration directory symlink"
	rm -rf "${XDG_CONFIG_HOME}/nvim" && mkdir -p "${XDG_CONFIG_HOME}"
	ln -fs "${DOTFILES_DIR}/nvim" "${XDG_CONFIG_HOME}/nvim"

	info "[neovim][configure] Install the neovim package for languages"
	info "[neovim][configure][languages] Python"
	python3 -m pip install --quiet neovim neovim-remote --user

	info "[neovim][configure][languages] Node.js"
	# shellcheck source=../../.nvm/nvm.sh
	source "${NVM_DIR}/nvm.sh" && npm install --quiet -g neovim
}

function main() {
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
