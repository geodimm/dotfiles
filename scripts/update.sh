#!/usr/bin/env bash

set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

# shellcheck source=./util.sh
source "${HOME}/dotfiles/scripts/util.sh"

main() {
	system
	nvim
	omz
}

system() {
	local funcname="${FUNCNAME[0]}"
	info "[${funcname}] Update packages"
	sudo apt-get update -qq
	sudo apt-get upgrade

	info "[${funcname}] Remove unused packages"
	sudo apt-get autoclean

	info "[${funcname}] Erase old downloaded archive files"
	sudo apt-get autoremove
}

nvim() {
	local funcname="${FUNCNAME[0]}"
	info "[${funcname}] Update neovim"
	make -C ~/dotfiles neovim-nightly

	info "[${funcname}] Update plugins"
	vim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
}

omz() {
	local funcname="${FUNCNAME[0]}"
	info "[${funcname}] Update"
	zsh -c 'source ${HOME}/.zshrc && omz update && exit'
}

main
