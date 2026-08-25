include Make/printing.mk
#================================================================================
# 
# 	"CANNED" RULES
#
# (A.K.A functions without parameters)
# ------------------------------------------------------------------------------
#


define clone-master
	git fetch -a
	git pull	
endef

define update-submodules	
	git submodule sync --recursive 
	git submodule update --init --recursive 
endef


.PHONY: clean down status fix-perms fix-perms-container git-operations

# SHIT THAT CREATES FILES
down down.log: fix-perms
	podman compose down 1&2>>down.log || true	

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



