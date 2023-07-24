SHELL := /bin/bash

.DEFAULT_GOAL := all
.PHONY: bat git kitty tig zsh

include test.mk

DOTFILES_DIR ?= ${HOME}/dotfiles
XDG_CONFIG_HOME ?= ${HOME}/.config
PLATFORM ?= $(shell uname | tr '[:upper:]' '[:lower:]')
GROUP := $(shell if [ ${PLATFORM} == "linux" ]; then  echo "${USER}"; else echo "staff"; fi)
HOMEBREW_PREFIX ?= $(shell if [ ${PLATFORM} == "linux" ]; then echo "/home/linuxbrew/.linuxbrew"; else echo "/opt/homebrew"; fi)

all: packages dirs fonts git node terminal tools neovim ## Install and configure everything (default)

help: ## Display help
	@grep -hE '^[a-zA-Z_0-9%-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

homebrew: ## Install Homebrew
	NONINTERACTIVE=1 bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

init: homebrew  ## Run the intial setup
	eval "$$(${HOMEBREW_PREFIX}/bin/brew shellenv)" && $(MAKE)

packages: ## Install system packages
	brew bundle --file="${DOTFILES_DIR}/Brewfile"

dirs: ## Create directories in $HOME
	install -d -m 0755 -o "${USER}" -g "${GROUP}" "${HOME}/bin"
	install -d -m 0755 -o "${USER}" -g "${GROUP}" "${HOME}/repos"

fonts: ## Install fonts
	@./scripts/fonts.sh

git: ## Configure git
	ln -fs "${DOTFILES_DIR}/git/gitconfig" "${HOME}/.gitconfig"
	touch "${DOTFILES_DIR}/git/commit-template"

nvm: ## Configure nvm
	install -d -m 0755 -o "${USER}" -g "${GROUP}" "${HOME}/.nvm"

node: nvm ## Install node
	source "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh" && nvm install stable

terminal: kitty zsh ohmyzsh fzf ## Setup the terminal

kitty: kitty-install kitty-configure ## Install and configure Kitty

kitty-install: ## Install Kitty
ifeq ($(PLATFORM),linux)
	install -d -m 0755 -o "${USER}" -g "${GROUP}" "${HOME}/.local"
	curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n
	sudo ln -fs "${HOME}/.local/kitty.app/bin/kitty" /usr/local/bin/
	sudo ln -fs "${HOME}/.local/kitty.app/bin/kitten" /usr/local/bin/
endif

kitty-configure: ## Configure Kitty
	@./scripts/kitty.sh

zsh: ## Install zsh
ifeq ($(PLATFORM),linux)
	brew install zsh
	sudo usermod -s "$$(type -P zsh)" "$$(whoami)"
endif

ohmyzsh: ohmyzsh-install ohmyzsh-configure ## Install and configure Oh My Zsh

ohmyzsh-install: ## Install Oh My Zsh
	sh -c "$$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended

ohmyzsh-configure: ## Configure Oh My Zsh
	@./scripts/ohmyzsh.sh configure

fzf: ## Configure FZF
	"${HOMEBREW_PREFIX}/opt/fzf/install" --no-bash --no-fish --key-bindings --completion --no-update-rc

tools: bat tig jqp

bat:
	mkdir -p "${XDG_CONFIG_HOME}/bat"
	ln -fs "${DOTFILES_DIR}/bat/config" "${XDG_CONFIG_HOME}/bat/config"

tig: ## Configure tig
	ln -fs "${DOTFILES_DIR}/tig/tigrc" "${HOME}/.tigrc"

jqp: JQP_VERSION=v0.0.3
jqp: ## Install jqp
	curl -s "https://raw.githubusercontent.com/geodimm/jqp/${JQP_VERSION}/scripts/install.sh" | bash

neovim: neovim-install neovim-configure ## Install and configure neovim

neovim-install: ## Install neovim
	brew install neovim

neovim-configure: ## Configure neovim
	rm -rf "${XDG_CONFIG_HOME}/nvim" && mkdir -p "${XDG_CONFIG_HOME}"
	ln -fs "${DOTFILES_DIR}/nvim" "${XDG_CONFIG_HOME}/"
	source "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh" && npm install --quiet -g neovim
