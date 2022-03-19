test: build ## Run tests
	docker run -t --rm dotfiles/test make

build: ## Build a docker image
	docker build -t dotfiles/test .
