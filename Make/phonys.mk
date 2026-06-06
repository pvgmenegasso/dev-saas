.PHONY: all


all: ps status status-full fix-perms fix-perms-container down clean


ps:
	$(call full-section, , podman compose ps )

status: ps

status-full:
	 $(call full-section, "PRINTING INFOS ABOUT PODMAN from lowest to highest abstraction level",$(call section, "ARTIFACTS", podman artifact ls)$(call section, "IMAGES", podman images)$(call section, "CONTAINERS", podman container list --all)$(call section, "PODS", podman pod ps)$(call section, "COMPOSE", podman compose ps 2>/dev/null))

fix-perms:
	sudo chown -R ${USER_ID}:${USER_GROUP} container-home

fix-perms-container:
	podman unshare chown -R "${USER_ID}":"${USER_GROUP}" container-home
down:
	podman compose down 2>/dev/null
	$(MAKE) fix-perms
clean:
	podman compose down -v
	podman rm -a

