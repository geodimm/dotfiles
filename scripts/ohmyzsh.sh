#!/usr/bin/env bash

set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

DOTFILES_DIR="${DOTFILES_DIR:=${HOME}/dotfiles}"
ZSH_CUSTOM="${HOME}/.oh-my-zsh/custom"

declare -a ZSH_CUSTOM_PLUGINS=(
	"themes/powerlevel10k=https://github.com/romkatv/powerlevel10k"
	"plugins/F-Sy-H=https://github.com/z-shell/F-Sy-H"
	"plugins/zsh-autosuggestions=https://github.com/zsh-users/zsh-autosuggestions"
	"plugins/zsh-completions=https://github.com/zsh-users/zsh-completions"
	"plugins/you-should-use=https://github.com/MichaelAquilina/zsh-you-should-use"
	"plugins/zsh-nvm=https://github.com/lukechilds/zsh-nvm"
	"plugins/fzf-tab=https://github.com/Aloxaf/fzf-tab"
)

function do_configure() {
	for value in "${ZSH_CUSTOM_PLUGINS[@]}"; do
		path="${value%%=*}"
		repo="${value##*=}"
		if [[ ! -d "${ZSH_CUSTOM}/${path}" ]]; then
			git clone --quiet "${repo}" "${ZSH_CUSTOM}/${path}"
		fi
	done

	ln -fs "${DOTFILES_DIR}/zsh/p10k/p10k.zsh" "${ZSH_CUSTOM}/p10k.zsh"
	ln -fs "${DOTFILES_DIR}/zsh/aliases.zsh" "${ZSH_CUSTOM}/aliases.zsh"
	ln -fs "${DOTFILES_DIR}/zsh/zshrc" "${HOME}/.zshrc"
	ln -fs "${DOTFILES_DIR}/zsh/zshenv" "${HOME}/.zshenv"
}

function do_update_plugins() {
	for value in "${ZSH_CUSTOM_PLUGINS[@]}"; do
		path="${value%%=*}"
		if [[ -d "${ZSH_CUSTOM}/${path}" ]]; then
			git -C "${ZSH_CUSTOM}/${path}" pull --quiet
		fi
	done
}

function main() {
	command=$1
	case $command in
	"configure")
		shift
		do_configure "$@"
		;;
	"update_plugins")
		shift
		do_update_plugins "$@"
		;;
	*)
		echo "$(basename "$0"): '$command' is not a valid command"
		;;
	esac
}

main "$@"
