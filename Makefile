# Makefile containing functions to print misc info
include Make/Makefile


# Checks out master, clone synch and build on directorie's make
define clone-master
        git fetch -a
        git pull
endef

define update-submodules
        git submodule sync --recursive 
        git submodule update --init --recursive 
endef

define submodule
	@echo making submodule $@
	git submodule set-branch --branch master $@
	$(call update-submodules)
	cd $@; $(call clone-master)
endef



.PHONY: stop all up code-container obsidian-container create-folders restart purge fix-perms fix-perms-container container-home down clean

USER_ID := $(shell id -u)
USER_GROUP := $(shell id -g)
LOGFILE := dev-saas.log

# Default target, create folders and start
all: code-container obsidian-container up

status:
	$(call status)

#==============================================================||
#							     ||
#							     ||
#		MAIN PODMAN CONTROL FLOWS                    ||
#						    	     ||
#--------------------------------------------------------------||

build: code-container obsidian-container
	podman compose build --build-arg USER_ID=${USER_ID} --build-arg USER_GROUP=${USER_GROUP}


up: build fix-perms-container
	# Save old log as bkp in logs/dev-saas.log.DATE.bkp	
	mv "${LOGFILE}" logs/"${LOGFILE}"."$(date +%d%m%y)".bkp || true
	podman compose up -d --build-arg USER_ID=${USER_ID} --build-arg USER_GROUP=${USER_GROUP}
	podman compose logs -f | tee >> "${LOGFILE}"

restart: down fix-perms-container up

stop: down fix-perms

down down.log:
	podman compose down >> logs/down.log || true



#==============================================================||
#							     ||
#							     ||
#		PROJECT STRUCTURE CREATION                   ||
#		(and other misc file operations)    	     ||
#--------------------------------------------------------------||

code-container obsidian-container: create-folders
	$(call submodule)
	cd $@ && $(MAKE) build || true

fix-perms:
	sudo chown -R ${USER_ID}:${USER_GROUP} container-home

fix-perms-container:
	podman unshare chown -R "${USER_ID}":"${USER_GROUP}" container-home

create-folders: container-home/obsidian container-home/vscode
	mkdir -p logs

container-home/obsidian:
	mkdir -p container-home/obsidian

container-home/vscode:
	mkdir -p container-home/vscode

clean clean.log: down
	rm $(wildcard *.log) | tee --output-error=warn -a clean.log

purge: down clean	
	podman container rm -af 
	podman volume rm -af
	find container-home/obsidian -mindepth 1 -maxdepth 1 -exec rm -rf "{}" \; || true
	find container-home/vscode -mindepth 1 -maxdepth 1 -exec rm -rf "{}" \; || true
	podman image rm -af
	podman rm -af
	podman system prune -af
	podman system reset -f
