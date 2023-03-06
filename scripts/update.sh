#!/usr/bin/env bash

set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

DOTFILES_DIR="${DOTFILES_DIR:=${HOME}/dotfiles}"
# shellcheck disable=SC1090
source "${DOTFILES_DIR}/scripts/util.sh"

function main() {
	update_system
	update_nvim
	update_omz
}

function update_system() {
	local funcname="${FUNCNAME[0]}"
	case "${PLATFORM}" in
	"linux")
		info "[${funcname}] Retrieve new lists of packages"
		sudo apt-get update -qq

		info "[${funcname}] Upgrade packages"
		sudo apt-get upgrade -y

		info "[${funcname}] Remove unused packages"
		sudo apt-get autoclean -y

		info "[${funcname}] Erase old downloaded archive files"
		sudo apt-get autoremove -y
		;;
	"darwin")
		info "[${funcname}] Retrieve new lists of packages"
		brew update
		info "[${funcname}] Upgrade packages"
		brew upgrade
		;;
	esac
}

function update_nvim() {
	local funcname="${FUNCNAME[0]}"
	info "[${funcname}] Update neovim"
	make -C "${DOTFILES_DIR}" neovim-install

	info "[${funcname}] Update plugins"
	nvim --headless "+Lazy! sync" +qa
	info "[${funcname}] Update LSP tools"
	nvim --headless -c 'autocmd User MasonToolsUpdateCompleted quitall' -c 'MasonToolsUpdate'
}

function update_omz() {
	local funcname="${FUNCNAME[0]}"
	info "[${funcname}] Update"
	(
		cd "${DOTFILES_DIR}"
		./scripts/ohmyzsh.sh update_plugins
	)
	zsh -c 'source ${HOME}/.zshrc && omz update && exit'
}

main
