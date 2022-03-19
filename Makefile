include test.mk

.DEFAULT_GOAL := all

all: system git languages terminal tools neovim ## Install and configure everything (default)
help: ## Display help
	@grep -hE '^[a-zA-Z_0-9%-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

system: system-install system-configure ## Install and configure
system-install: ## Install system packages
	@./scripts/system.sh install
system-configure: ## Create directories, install fonts, etc.
	@./scripts/system.sh configure
git: ## Configure git
	@./scripts/git.sh configure
gnome-terminal: ## Install themes for gnome-terminal
	@./scripts/gnome-terminal.sh configure

languages: go rust lua node ## Install programming languages
go: ## Install Go
	@./scripts/go.sh install
rust: ## Install Rust
	@./scripts/rust.sh install
lua: ## Install Lua
	@./scripts/lua.sh install
node: nvm ## Install Node.js
	@./scripts/node.sh install
nvm: ## Install Node version manager
	@./scripts/nvm.sh install

terminal: tmux zsh ohmyzsh fzf ## Setup the terminal
tmux: ## Configure tmux
	@./scripts/tmux.sh configure
zsh: ## Configure zsh
	@./scripts/zsh.sh configure
ohmyzsh: ohmyzsh-install ohmyzsh-configure ## Install and configure Oh My Zsh
ohmyzsh-install: ## Install Oh My Zsh
	@./scripts/ohmyzsh.sh install
ohmyzsh-configure: ## Configure Oh My Zsh
	@./scripts/ohmyzsh.sh configure
fzf: ## Install FZF
	@./scripts/fzf.sh install

tools: lsd bat tig jqp
lsd: ## Install lsd
	@./scripts/lsd.sh install
bat: bat-install bat-configure ## Install and configure bat
bat-install: ## Install bat
	@./scripts/bat.sh install
bat-configure: ## Configure bat
	@./scripts/bat.sh configure
tig: ## Configure tig
	@./scripts/tig.sh configure
jqp: ## Install jqp
	@./scripts/jqp.sh install

neovim: tree-sitter ## Configure neovim
	@./scripts/neovim.sh configure
neovim-nightly: ## Install neovim (nightly build)
	@./scripts/neovim-nightly.sh install
tree-sitter: ## Install tree-sitter
	@./scripts/tree-sitter.sh install
