SHELL := /bin/bash

.DEFAULT_GOAL := all
.PHONY: bat eza git ghostty tig zsh golangci-lint

include test.mk

DOTFILES_DIR ?= ${HOME}/dotfiles
XDG_CONFIG_HOME ?= ${HOME}/.config
PLATFORM ?= $(shell uname | tr '[:upper:]' '[:lower:]')
GROUP := $(shell if [ ${PLATFORM} == "linux" ]; then  echo "${USER}"; else echo "staff"; fi)
HOMEBREW_PREFIX ?= $(shell if [ ${PLATFORM} == "linux" ]; then echo "/home/linuxbrew/.linuxbrew"; else echo "/opt/homebrew"; fi)

all: packages dirs fonts git languages terminal tools neovim ## Install and configure everything (default)

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

languages: node rust java ## Setup languages

nvm: ## Configure nvm
	install -d -m 0755 -o "${USER}" -g "${GROUP}" "${HOME}/.nvm"

node: nvm ## Install node
	source "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh" && nvm install stable

rust: ## Install Rust
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y

java: ## Configure Java
ifeq ($(PLATFORM),darwin)
	sudo ln -fs "${HOMEBREW_PREFIX}/opt/openjdk/libexec/openjdk.jdk" "/Library/Java/JavaVirtualMachines/openjdk.jdk"
endif

terminal: ghostty zsh ohmyzsh ## Setup the terminal

ghostty: ghostty-install ghostty-configure # Install and configure Ghostty

ghostty-install: ## Install Ghostty
ifeq ($(PLATFORM),linux)
	@echo Please follow https://ghostty.org/docs/install/binary
endif

ghostty-configure: ## Configure Ghostty
	@./scripts/ghostty.sh configure

zsh: ## Install zsh
ifeq ($(PLATFORM),linux)
	brew install zsh --yes
	sudo usermod -s "$$(type -P zsh)" "$$(whoami)"
endif

ohmyzsh: ohmyzsh-install ohmyzsh-configure ## Install and configure Oh My Zsh

ohmyzsh-install: ## Install Oh My Zsh
	sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

ohmyzsh-configure: ## Configure Oh My Zsh
	@./scripts/ohmyzsh.sh configure

tools: bat eza tig jqp golangci-lint

bat: ## Configure bat
	mkdir -p "${XDG_CONFIG_HOME}/bat"
	ln -fs "${DOTFILES_DIR}/bat/config" "${XDG_CONFIG_HOME}/bat/config"

eza: ## Configure eza
	mkdir -p "${XDG_CONFIG_HOME}/eza"
	ln -fs "${DOTFILES_DIR}/eza/theme.yml" "${XDG_CONFIG_HOME}/eza/theme.yml"

tig: ## Configure tig
	ln -fs "${DOTFILES_DIR}/tig/tigrc" "${HOME}/.tigrc"

jqp: JQP_VERSION=v0.0.4
jqp: ## Install jqp
	curl -s "https://raw.githubusercontent.com/geodimm/jqp/${JQP_VERSION}/scripts/install.sh" | bash

golangci-lint: ## Configure golangci-lint
	ln -fs "${DOTFILES_DIR}/golangci-lint/golangci.yml" "${HOME}/.golangci.yml"

neovim: neovim-install neovim-configure ## Install and configure neovim

neovim-install: ## Install neovim
	brew install neovim --yes

neovim-nightly: ## Install neovim-nightly
ifeq ($(PLATFORM),linux)
	wget --quiet https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage -O ~/bin/nvim && chmod +x ~/bin/nvim
endif

neovim-configure: ## Configure neovim
	rm -rf "${XDG_CONFIG_HOME}/nvim" && mkdir -p "${XDG_CONFIG_HOME}"
	ln -fs "${DOTFILES_DIR}/nvim" "${XDG_CONFIG_HOME}/"
	source "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh" && npm install --quiet -g neovim
