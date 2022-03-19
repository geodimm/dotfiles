include test.mk

.DEFAULT_GOAL := all

all: system git-configure languages terminal neovim ## Install and configure everything (default)
help: ## Display help
	@grep -hE '^[a-zA-Z_0-9%-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

system: system-install system-configure ## Install and configure
system-install: ## Install system packages
	@./scripts/system.sh install
system-configure: ## Create directories, install fonts, etc.
	@./scripts/system.sh configure
git-configure: ## Configure git
	@./scripts/git.sh configure
gnome-terminal: ## Install a few themes for gnome-terminal
	@./scripts/gnome-terminal.sh configure

languages: go rust lua node ## Setup programming languages
go: go-install ## Setup Go
go-install: ## Install Go
	@./scripts/go.sh install
rust: rust-install ## Setup Rust
rust-install: ## Install Rust
	@./scripts/rust.sh install
lua: lua-install ## Setup Lua
lua-install: ## Install Lua
	@./scripts/lua.sh install
node: node-install ## Setup Node.js
node-install: nvm-install # Install Node.js
	@./scripts/node.sh install
nvm-install: ## Install Node version manager
	@./scripts/nvm.sh install

terminal: tmux zsh ohmyzsh fzf ## Setup the terminal
tmux: tmux-configure ## Setup tmux
tmux-configure: ## Configure tmux
	@./scripts/tmux.sh configure
zsh: zsh-configure ## Setup zsh
zsh-configure: ## Configure zsh
	@./scripts/zsh.sh configure
ohmyzsh: ohmyzsh-install ohmyzsh-configure ## Setup OhMyZsh
ohmyzsh-install: ## Install Oh My Zsh
	@./scripts/ohmyzsh.sh install
ohmyzsh-configure: ## Configure Oh My Zsh
	@./scripts/ohmyzsh.sh configure
fzf: fzf-install ## Setup FZF
fzf-install: ## Install FZF
	@./scripts/fzf.sh install

tools: lsd bat tig jqp
lsd: lsd-install ## Setup lsd
lsd-install:
	@./scripts/lsd.sh install
bat: bat/install bat/configure ## Setup bat
bat-install: ## Install bat
	@./scripts/bat.sh install
bat-configure: ## Configure bat
	@./scripts/bat.sh configure
tig: tig-configure ## Setup tig
tig-configure: ## Configure tig
	@./scripts/tig.sh configure
jqp: jqp-install ## Setup jqp
jqp-install: ## Install jqp
	@./scripts/jqp.sh install

neovim: neovim-configure ## Setup neovim (stable)
neovim-configure: tree-sitter ## Configure neovim
	@./scripts/neovim.sh configure
neovim-nightly: neovim-nightly-install neovim-nightly-configure ## Setup neovim (nightly build)
neovim-nightly-install: ## Install neovim (nightly build)
	@./scripts/neovim-nightly.sh install
neovim-nightly-configure: ## Configure neovim (nightly build)
	@./scripts/neovim-nightly.sh configure
tree-sitter: tree-sitter-install ## Setup tree-sitter
tree-sitter-install: ## Install tree-sitter
	@./scripts/tree-sitter.sh install
