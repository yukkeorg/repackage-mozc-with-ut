PROJECT := build_and_pacakge-mozc
DIST := ubuntu
DIST_TAG ?= oracular
IMAGE_NAME := $(DIST):$(DIST_TAG)
DOCKER_TAG_BASE := $(PROJECT)-$(DIST)-$(DIST_TAG)
DOCKER_IMAGE_NAME := $(DOCKER_TAG_BASE)
CONTAINER_NAME := $(PROJECT)

.PHONY: all copy_pkgs_to_local build_and_pacakge create_container build_image clean_all clean clean_docker_cache

all: build_image create_container rebuild copy_to_host

copy_to_host:
	docker container cp $(CONTAINER_NAME):/home/repackage/packages - | tar xf -
	@echo
	@echo 'We put packages that rebuilded to in "package".'
	@echo 'Check it out.'

rebuild:
	docker container start "$(CONTAINER_NAME)"
	docker container exec  "$(CONTAINER_NAME)" bash ./rebuild.sh
	docker container stop  "$(CONTAINER_NAME)"
	@echo
	@echo 'Repackage done.'

create_container:
	if [ -n `docker container ls -q -a -f name=$(CONTAINER_NAME)` ]; then \
		docker container rm -f "$(CONTAINER_NAME)"; \
    fi
	docker container create -it --name "$(CONTAINER_NAME)" "$(DOCKER_IMAGE_NAME)"

build_image: rebuild.sh
	docker image build --tag "$(DOCKER_IMAGE_NAME)" --rm --build-arg IMAGE="$(IMAGE_NAME)" .

rebuild.sh: rebuild.sh.in
	sed "s/@@UBUNTU_DIST@@/$(DIST_TAG)/g" "$<" > $@
	chmod +x $@

clean_all: clean clean_docker_cache

clean:
	docker container stop  $(CONTAINER_NAME)
	docker container rm -f $(CONTAINER_NAME)
	@rm -rf pkgs.tar packages rebuild.sh

clean_docker_cache:
	docker builder prune -f

