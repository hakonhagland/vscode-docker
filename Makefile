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
	@mkdir -p $(ROOT)/share
	@docker run --user $(shell id -u):$(shell id -g) \
	            -v $(ROOT)/share:/home/$(USERNAME)/share \
	            -it --rm $(TAG_NAME)

run-vscode:
	@echo "Running Docker container with VSCode..."
	@xhost +local:docker
	@docker run --user $(shell id -u):$(shell id -g) \
	            -v $(ROOT)/share:/home/$(USERNAME)/share \
	            -v /tmp/.X11-unix:/tmp/.X11-unix \
	            -e DISPLAY=$(DISPLAY) \
	            -it --rm $(TAG_NAME) code /home/$(USERNAME)/share
	@xhost -local:docker
