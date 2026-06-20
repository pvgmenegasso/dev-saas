include Make/Makefile
.PHONY: all up code-container obsidian-container create-folders restart purge 

USER_ID := $(shell id -u)
USER_GROUP := $(shell id -g)


all: purge code-container obsidian-container

# Checks out master, clone synch and build on directorie's make
define submodule
	@echo making submodule $@
	git submodule set-branch --branch master $@
	$(clone-master)
	$(update-submodules)
	-cd $@ && $(MAKE)
endef


code-container obsidian-container: create-folders
	$(submodule)


up: down code-container obsidian-container create-folders fix-perms-container
	podman compose up -d --build-arg USER_ID=${USER_ID} --build-arg USER_GROUP=${USER_GROUP}
 

create-folders: container-home/obsidian container-home/vscode

container-home/obsidian:
	mkdir -p container-home/obsidian

container-home/vscode:
	mkdir -p container-home/vscode

restart: down up

purge: down clean	
	podman container rm -af 
	podman volume rm -af
	sudo rm -rf container-home
	mkdir -p container-home/obsidian container-home/vscode
	find container-home/obsidian -mindepth 1 -maxdepth 1 -exec rm -rf "{}" \; || true
	find container-home/vscode -mindepth 1 -maxdepth 1 -exec rm -rf "{}" \; || true
	podman image rm -af
	podman rm -af
	podman system prune -af
	podman system reset -f
