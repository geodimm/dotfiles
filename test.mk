ifdef UBUNTU_VERSION
UBUNTU_VERSION := $(subst ubuntu-,,$(UBUNTU_VERSION))
else
UBUNTU_VERSION = 20.04
endif

test: build ## Run tests
	docker run -t --rm dotfiles/test make

build: ## Build a docker image
	docker build -t dotfiles/test --build-arg UBUNTU_VERSION=$(UBUNTU_VERSION) .
