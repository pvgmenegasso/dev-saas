.PHONY: restart up build purge create-folders build-code-container all

IMAGE := pvgm/code-container:local
USER_ID := $(shell id -u)
USER_GROUP := $(shell id -g)

include Make/*.mk

all: build up

build-code-container:
	cd code-container && $(MAKE)

build: build-code-container
	podman compose build  --build-arg USER_ID=${USER_ID} --build-arg USER_GROUP=${USER_GROUP}

up: create-folders fix-perms-container build
	podman compose up -d

create-folders: container-home/obsidian container-home/vscode

container-home/obsidian:
	mkdir -p container-home/obsidian

container-home/vscode:
	mkdir -p container-home/vscode

restart: down up

purge: clean down
	podman container rm -af 
	podman volume rm -af
	rm -rf container-home
	mkdir -p container-home/obsidian container-home/vscode
	find container-home/obsidian -mindepth 1 -maxdepth 1 -exec rm -rf "{}" \; || true
	find container-home/vscode -mindepth 1 -maxdepth 1 -exec rm -rf "{}" \; || true
	podman image rm -af
	podman rm -af
	podman system prune -af
	podman system reset -f

