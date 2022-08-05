#!/usr/bin/env bash

set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

# shellcheck source=./util.sh
source "${HOME}/dotfiles/scripts/util.sh"

function main() {
	system
	nvim
	gopls
	omz
}

function system() {
	local funcname="${FUNCNAME[0]}"
	info "[${funcname}] Retrieve new lists of packages"
	sudo apt-get update -qq

	info "[${funcname}] Upgrade packages"
	sudo apt-get upgrade -y

	info "[${funcname}] Remove unused packages"
	sudo apt-get autoclean -y

	info "[${funcname}] Erase old downloaded archive files"
	sudo apt-get autoremove -y
}

function nvim() {
	local funcname="${FUNCNAME[0]}"
	info "[${funcname}] Update neovim"
	make -C ~/dotfiles neovim-nightly

	info "[${funcname}] Update plugins"
	vim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
}

function gopls() {
	local funcname="${FUNCNAME[0]}"
	info "[${funcname}] Update gopls"
	go install golang.org/x/tools/gopls@latest
}

function omz() {
	local funcname="${FUNCNAME[0]}"
	info "[${funcname}] Update"
	zsh -c 'source ${HOME}/.zshrc && omz update && exit'
	"${HOME}/dotfiles/scripts/ohmyzsh.sh" update_plugins
}

main
