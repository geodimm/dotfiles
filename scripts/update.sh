#!/usr/bin/env bash

set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

DOTFILES_DIR="${DOTFILES_DIR:=${HOME}/dotfiles}"

function main() {
	update_system
	update_neovim
	update_omz
}

function update_system() {
	brew update
	brew upgrade
}

function update_neovim() {
	nvim --headless "+Lazy! sync" +qa
	nvim --headless -c 'autocmd User MasonToolsUpdateCompleted quitall' -c 'MasonToolsUpdate'
}

function update_omz() {
	(
		cd "${DOTFILES_DIR}"
		./scripts/ohmyzsh.sh update_plugins
	)
	zsh -c 'source ${HOME}/.zshrc && omz update && exit'
}

main
