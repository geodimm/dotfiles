#!/usr/bin/env bash

set -e

# shellcheck source=../scripts/util.sh
source "$(pwd)/scripts/util.sh"

ZSH="${HOME}/.oh-my-zsh"
ZSH_CUSTOM="${ZSH}/custom"

declare -A ZSH_CUSTOM_PLUGINS=(
	["plugins/F-Sy-H"]="https://github.com/z-shell/F-Sy-H"
	["plugins/zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions"
	["plugins/zsh-completions"]="https://github.com/zsh-users/zsh-completions"
	["plugins/fzf-tab"]="https://github.com/Aloxaf/fzf-tab"
	["plugins/you-should-use"]="https://github.com/MichaelAquilina/zsh-you-should-use"
	["plugins/zsh-nvm"]="https://github.com/lukechilds/zsh-nvm"
	["themes/powerlevel10k"]="https://github.com/romkatv/powerlevel10k"
)

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
	for path in "${!ZSH_CUSTOM_PLUGINS[@]}"; do
		if [[ ! -d "${ZSH_CUSTOM}/$path" ]]; then
			git clone --quiet "${ZSH_CUSTOM_PLUGINS[$path]}" "${ZSH_CUSTOM}/$path"
		fi
	done

	info "[ohmyzsh][configure] Create symlinks"
	ln -fs "$(pwd)/zsh/p10k/p10k.zsh" "${ZSH_CUSTOM}/p10k.zsh"
	ln -fs "$(pwd)/zsh/aliases.zsh" "${ZSH_CUSTOM}/aliases.zsh"
	ln -fs "$(pwd)/zsh/zshrc" "${HOME}/.zshrc"
	ln -fs "$(pwd)/zsh/zshenv" "${HOME}/.zshenv"
}

do_update_plugins() {
	info "[ohmyzsh] Update plugins"
	for path in "${!ZSH_CUSTOM_PLUGINS[@]}"; do
		if [[ -d "${ZSH_CUSTOM}/$path" ]]; then
			{
				info "[ohmyzsh][update] Update $path"
				cd "${ZSH_CUSTOM}/$path" && git pull --quiet
			}
		fi
	done
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
	"update_plugins")
		shift
		do_update_plugins "$@"
		;;
	*)
		error "$(basename "$0"): '$command' is not a valid command"
		;;
	esac
}

main "$@"
