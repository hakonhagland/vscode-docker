ROOT := $(shell pwd)

.PHONY: build run

USERNAME := dockeruser
TAG_NAME := ubuntu-vscode

build:
	@echo "Building Docker image..."
	@docker build --build-arg HOST_UID=$(shell id -u) \
	              --build-arg HOST_GID=$(shell id -g) \
	              --build-arg USERNAME=$(USERNAME) \
	              -t $(TAG_NAME) .

run:
	@echo "Running Docker container..."
	@docker run --user $(shell id -u):$(shell id -g) \
	            -v $(ROOT)/share:/home/$(USERNAME)/share \
	            -it --rm $(TAG_NAME)

