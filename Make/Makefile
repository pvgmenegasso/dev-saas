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


.PHONY: all status fix-perms fix-perms-container 

all: ;

# SHIT THAT CREATES FILES
down down.log:
	podman compose down 2>/dev/null 1>>down.log

clean clean.log: down
	rm $(wildcard *.log) | tee --output-error=warn -a clean.log
	podman rm -a >>  clean.log

# VIRTUAL SHIT BELOW

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
