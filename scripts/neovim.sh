#!/usr/bin/env bash

set -e

# shellcheck source=../scripts/util.sh
source "$(pwd)/scripts/util.sh"

RVM_DIR="${HOME}/.rvm"
NVM_DIR="${HOME}/.nvm"

do_install() {
	if is_installed nvim; then
		info "[neovim] Already installed"
		return
	fi

	info "[neovim] Install"
	sudo add-apt-repository ppa:neovim-ppa/stable -y
	sudo apt update
	sudo apt install -y neovim
}

do_configure() {
	info "[neovim] Configure"
	info "[neovim][configure] Set as default editor"
	local nvim_path
	nvim_path="$(type -P nvim)"
	sudo update-alternatives --install /usr/bin/vi vi "$nvim_path" 60
	sudo update-alternatives --set vi "$nvim_path"
	sudo update-alternatives --install /usr/bin/vim vim "$nvim_path" 60
	sudo update-alternatives --set vim "$nvim_path"
	sudo update-alternatives --install /usr/bin/editor editor "$nvim_path" 60
	sudo update-alternatives --set editor "$nvim_path"

	info "[neovim][configure] Create symlinks"
	rm -f "${XDG_CONFIG_HOME}/nvim"
	ln -fs "$(pwd)/nvim" "${XDG_CONFIG_HOME}/nvim"

	info "[neovim][configure] Install the neovim package for languages"
	python3 -m pip install neovim neovim-remote --user
	# shellcheck source=../../.rvm/scripts/rvm
	source "${RVM_DIR}/scripts/rvm" && gem install neovim
	# shellcheck source=../../.nvm/nvm.sh
	source "${NVM_DIR}/nvm.sh" && npm install -g neovim

	info "[neovim][configure] Install dependencies for LSP"
	# shellcheck source=../../.nvm/nvm.sh
	source "${NVM_DIR}/nvm.sh"
	info "[neovim][configure][deps] yarn"
	npm install -g yarn
	info "[neovim][configure][deps] markdownlint-cli"
	npm install -g markdownlint-cli
	info "[neovim][configure][deps] luaformatter"
	sudo luarocks install --server=https://luarocks.org/dev luaformatter
	info "[neovim][configure][deps] shfmt"
	/usr/local/go/bin/go install mvdan.cc/sh/v3/cmd/shfmt@latest
	info "[neovim][configure][deps] golangci-lint"
	/usr/local/go/bin/go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
	ln -fs "$(pwd)/golangci-lint/golangci.yml" "${HOME}/.golangci.yml"
}

main() {
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
