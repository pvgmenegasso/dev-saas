include Make/printing.mk
#================================================================================
# 
# 	"CANNED" RULES
#
# (A.K.A functions without parameters)
# ------------------------------------------------------------------------------
#

# PRINTING 
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
define status
	$(call full-section, "PRINTING INFOS ABOUT PODMAN from lowest to highest abstraction level",$(status-artifacts) $(status-images) $(status-containers) $(status-pods) $(status-compose))
endef
