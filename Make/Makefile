define clone-master
	$(shell if [ -f submodules.log ]; then \
		git fetch origin master >> submodules.log && \
		git pull origin master >> submodules.log && \
		git checkout master >> submodules.log; \
	fi)
endef

define update-submodules
	$(shell if [ -f submodules.log ]; then \
		git submodule sync --recursive >> submodules.log && \
		git submodule update --recursive >> submodules.log; \
	fi)
endef


.PHONY: status fix-perms fix-perms-container 

# SHIT THAT CREATES FILES
down.log:
	podman compose down 2>/dev/null | tee --output-error=warn down.log

clean.log: down.log
	$(shell rm ${filelist} | tee --output-error=warn -a clean.log)
	podman rm -a | tee --output-error=warn clean.log

GNUmakefile: clean.log
	echo ${filelist}
	$(MAKE) --always-remake -p | tee --output-error=exit GNUmakefile.log
	$(MAKE) -p 2>/dev/null | tee --output-error=warn -a GNUmakefile
	$(MAKE) clean.log 2>/dev/null


# VIRTUAL SHIT BELOW
listfile:=$(shell ls *.log)
filelist=${listfile} GNUmakefile

status:
	$(call full-section, \
		"PRINTING INFOS ABOUT PODMAN from lowest to highest abstraction level",\
		$(call section, \
			"ARTIFACTS", \
			"podman artifact ls") \
		$(call section, \
			"IMAGES", \
			"podman images") \
		$(call section, \
			"CONTAINERS", \
			"podman container list --all") \
		$(call section, \
			"PODS", \
			"podman pod ps") \
		$(call section, \
			"COMPOSE", \
			"podman compose ps 2>/dev/nulll") \
	)



fix-perms:
	sudo chown -R ${USER_ID}:${USER_GROUP} container-home

fix-perms-container:
	podman unshare chown -R "${USER_ID}":"${USER_GROUP}" container-home
