#!/usr/bin/env bash

set -e

# shellcheck source=../scripts/util.sh
source "$(pwd)/scripts/util.sh"

ZSH="${HOME}/.oh-my-zsh"
ZSH_CUSTOM="${ZSH}/custom"

do_install() {
	if [[ -d "${ZSH}" ]]; then
		info "[ohmyzsh] Already installed"
		return
	fi

	info "[ohmyzsh] Install"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
}

do_configure() {
	info "[ohmyzsh] Configure"
	info "[ohmyzsh][configure] Download plugins"
	declare -A plugins=(
		["plugins/fast-syntax-highlighting"]="https://github.com/z-shell/fast-syntax-highlighting"
		["plugins/zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions"
		["plugins/zsh-completions"]="https://github.com/zsh-users/zsh-completions"
		["plugins/fzf-tab"]="https://github.com/Aloxaf/fzf-tab"
		["plugins/you-should-use"]="https://github.com/MichaelAquilina/zsh-you-should-use"
		["themes/powerlevel10k"]="https://github.com/romkatv/powerlevel10k"
	)
	for path in "${!plugins[@]}"; do
		if [[ ! -d "${ZSH_CUSTOM}/$path" ]]; then
			git clone "${plugins[$path]}" "${ZSH_CUSTOM}/$path"
		fi
	done

	info "[ohmyzsh][configure] Create symlinks"
	ln -fs "$(pwd)/zsh/p10k.zsh" "${ZSH_CUSTOM}/p10k.zsh"
	ln -fs "$(pwd)/zsh/aliases.zsh" "${ZSH_CUSTOM}/aliases.zsh"
	ln -fs "$(pwd)/zsh/zshrc" "${HOME}/.zshrc"
	ln -fs "$(pwd)/zsh/zshenv" "${HOME}/.zshenv"
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
