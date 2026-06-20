include Make/printing.mk
#================================================================================
# 
# 	"CANNED" RULES
#
# (A.K.A functions without parameters)
# ------------------------------------------------------------------------------
#
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
down down.log: fix-perms
	-podman compose down 2>/dev/null 1>>down.log

clean clean.log: down
	rm $(wildcard *.log) | tee --output-error=warn -a clean.log
	podman rm -a >>  clean.log

# VIRTUAL SHIT BELOW

fix-perms:
	sudo chown -R ${USER_ID}:${USER_GROUP} container-home

fix-perms-container:
	podman unshare chown -R "${USER_ID}":"${USER_GROUP}" container-home

# PRINTING 
#

define status-artifacts
$(call section, "ARTIFACTS", podman artifact ls)
endef
define status-images
$(call section, "IMAGES", podman images)
endef
define status-containers
$(call section, "CONTAINERS", podman container list --all)
endef
define status-ṕods
$(call section, "PODS", podman pod ps)
endef
define status-compose
$(call section,"COMPOSE",podman compose ps 2>/dev/null)
endef

status:
	$(call full-section, "PRINTING INFOS ABOUT PODMAN from lowest to highest abstraction level",$(status-artifacts) $(status-images) $(status-containers) $(status-pods) $(status-compose))



