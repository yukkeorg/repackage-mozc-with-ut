UBUNTU_IMAGE_TAG := kinetic
DOCKER_TAG_BASE := repackage-mozc-$(UBUNTU_IMAGE_TAG)
DOCKER_IMAGE_TAG := $(DOCKER_TAG_BASE)
CONTAINER_NAME := repackage-mozc

.PHONY: all copy_to_local repackage create_container build_image clean

all: copy_to_local

copy_to_local: repackage
	docker container cp $(CONTAINER_NAME):/home/repackage/packages - | tar xf - --strip-components=2

repackage: create_container
	docker container start ${CONTAINER_NAME}
	docker container exec ${CONTAINER_NAME} bash ./repackage.sh
	docker container stop $(CONTAINER_NAME)

create_container: build_image
	docker container rm -f $(CONTAINER_NAME)
	docker container create -it --rm --name $(CONTAINER_NAME) $(DOCKER_IMAGE_TAG)

build_image:
	docker image build --tag $(DOCKER_IMAGE_TAG) --rm --build-arg UBUNTU_IMAGE_TAG=$(UBUNTU_IMAGE_TAG) .

clean:
	docker container rm -f $(CONTAINER_NAME)
	docker image rm -f $(DOCKER_IMAGE_TAG)
	@rm -rf pkgs.tar packages

