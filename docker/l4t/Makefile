#!make

# Default squash as our base images need to be small unless overridden
DOCKER_BUILD_ARGS ?= --squash

.PHONY: all

all: 32.2.1 32.2 32.1

32.2.1: $(addprefix 32.2.1-,jax jax-8gb tx2 tx2i tx2-4gb tx1 nano nano-dev)

32.2.1-jax:
	$(DOCKER) build $(DOCKER_BUILD_ARGS) \
					--build-arg VERSION_ID="$(BIONIC_VERSION_ID)" \
					--build-arg DEPENDENCIES_IMAGE=$(REPO):32.2.1-jax-jetpack-4.2.2-deps \
					-t $(REPO):$@ \
					-f $(CURDIR)/32.2.1/jax/Dockerfile \
					.

32.2.1-jax-8gb:
	$(DOCKER) build $(DOCKER_BUILD_ARGS) \
					--build-arg VERSION_ID="$(BIONIC_VERSION_ID)" \
					--build-arg DEPENDENCIES_IMAGE=$(REPO):32.2.1-jax-8gb-jetpack-4.2.2-deps \
					-t $(REPO):$@ \
					-f $(CURDIR)/32.2.1/jax-8gb/Dockerfile \
					.

32.2.1-tx2:
	$(DOCKER) build $(DOCKER_BUILD_ARGS) \
					--build-arg VERSION_ID="$(BIONIC_VERSION_ID)" \
					--build-arg DEPENDENCIES_IMAGE=$(REPO):32.2.1-tx2-jetpack-4.2.2-deps \
					-t $(REPO):$@ \
					-f $(CURDIR)/32.2.1/tx2/Dockerfile \
					.

32.2.1-tx2i:
	$(DOCKER) build $(DOCKER_BUILD_ARGS) \
					--build-arg VERSION_ID="$(BIONIC_VERSION_ID)" \
					--build-arg DEPENDENCIES_IMAGE=$(REPO):32.2.1-tx2i-jetpack-4.2.2-deps \
					-t $(REPO):$@ \
					-f $(CURDIR)/32.2.1/tx2i/Dockerfile \
					.

32.2.1-tx2-4gb:
	$(DOCKER) build $(DOCKER_BUILD_ARGS) \
					--build-arg VERSION_ID="$(BIONIC_VERSION_ID)" \
					--build-arg DEPENDENCIES_IMAGE=$(REPO):32.2.1-tx2-4gb-jetpack-4.2.2-deps \
					-t $(REPO):$@ \
					-f $(CURDIR)/32.2.1/tx2-4gb/Dockerfile \
					.

32.2.1-tx1:
	$(DOCKER) build $(DOCKER_BUILD_ARGS) \
					--build-arg VERSION_ID="$(BIONIC_VERSION_ID)" \
					--build-arg DEPENDENCIES_IMAGE=$(REPO):32.2.1-tx1-jetpack-4.2.2-deps \
					-t $(REPO):$@ \
					-f $(CURDIR)/32.2.1/tx1/Dockerfile \
					.

32.2.1-nano:
	$(DOCKER) build $(DOCKER_BUILD_ARGS) \
					--build-arg VERSION_ID="$(BIONIC_VERSION_ID)" \
					--build-arg DEPENDENCIES_IMAGE=$(REPO):32.2.1-nano-jetpack-4.2.2-deps \
					-t $(REPO):$@ \
					-f $(CURDIR)/32.2.1/nano/Dockerfile \
					.

32.2.1-nano-dev:
	$(DOCKER) build $(DOCKER_BUILD_ARGS) \
					--build-arg VERSION_ID="$(BIONIC_VERSION_ID)" \
					--build-arg DEPENDENCIES_IMAGE=$(REPO):32.2.1-nano-dev-jetpack-4.2.2-deps \
					-t $(REPO):$@ \
					-f $(CURDIR)/32.2.1/nano-dev/Dockerfile \
					.


32.2: $(addprefix 32.2-,jax tx2 tx2i tx2-4gb tx1 nano nano-dev)

32.2-jax:
	$(DOCKER) build $(DOCKER_BUILD_ARGS) \
					--build-arg VERSION_ID="$(BIONIC_VERSION_ID)" \
					--build-arg DEPENDENCIES_IMAGE=$(REPO):32.2-jax-jetpack-4.2.1-deps \
					-t $(REPO):$@ \
					-f $(CURDIR)/32.2/jax/Dockerfile \
					.

32.2-tx2:
	$(DOCKER) build $(DOCKER_BUILD_ARGS) \
					--build-arg VERSION_ID="$(BIONIC_VERSION_ID)" \
					--build-arg DEPENDENCIES_IMAGE=$(REPO):32.2-tx2-jetpack-4.2.1-deps \
					-t $(REPO):$@ \
					-f $(CURDIR)/32.2/tx2/Dockerfile \
					.

32.2-tx2i:
	$(DOCKER) build $(DOCKER_BUILD_ARGS) \
					--build-arg VERSION_ID="$(BIONIC_VERSION_ID)" \
					--build-arg DEPENDENCIES_IMAGE=$(REPO):32.2-tx2i-jetpack-4.2.1-deps \
					-t $(REPO):$@ \
					-f $(CURDIR)/32.2/tx2i/Dockerfile \
					.

32.2-tx2-4gb:
	$(DOCKER) build $(DOCKER_BUILD_ARGS) \
					--build-arg VERSION_ID="$(BIONIC_VERSION_ID)" \
					--build-arg DEPENDENCIES_IMAGE=$(REPO):32.2-tx2-4gb-jetpack-4.2.1-deps \
					-t $(REPO):$@ \
					-f $(CURDIR)/32.2/tx2-4gb/Dockerfile \
					.

32.2-tx1:
	$(DOCKER) build $(DOCKER_BUILD_ARGS) \
					--build-arg VERSION_ID="$(BIONIC_VERSION_ID)" \
					--build-arg DEPENDENCIES_IMAGE=$(REPO):32.2-tx1-jetpack-4.2.1-deps \
					-t $(REPO):$@ \
					-f $(CURDIR)/32.2/tx1/Dockerfile \
					.

32.2-nano:
	$(DOCKER) build $(DOCKER_BUILD_ARGS) \
					--build-arg VERSION_ID="$(BIONIC_VERSION_ID)" \
					--build-arg DEPENDENCIES_IMAGE=$(REPO):32.2-nano-jetpack-4.2.1-deps \
					-t $(REPO):$@ \
					-f $(CURDIR)/32.2/nano/Dockerfile \
					.

32.2-nano-dev:
	$(DOCKER) build $(DOCKER_BUILD_ARGS) \
					--build-arg VERSION_ID="$(BIONIC_VERSION_ID)" \
					--build-arg DEPENDENCIES_IMAGE=$(REPO):32.2-nano-dev-jetpack-4.2.1-deps \
					-t $(REPO):$@ \
					-f $(CURDIR)/32.2/nano-dev/Dockerfile \
					.


32.1: $(addprefix 32.1-,jax tx2 jax-tx2 nano-dev)

32.1-jax:
	$(DOCKER) build $(DOCKER_BUILD_ARGS) \
					--build-arg VERSION_ID="$(BIONIC_VERSION_ID)" \
					--build-arg DEPENDENCIES_IMAGE=$(REPO):32.1-jax-jetpack-4.2-deps \
					-t $(REPO):$@ \
					-f $(CURDIR)/32.1/jax-tx2/Dockerfile \
					.

32.1-tx2:
	$(DOCKER) build $(DOCKER_BUILD_ARGS) \
					--build-arg VERSION_ID="$(BIONIC_VERSION_ID)" \
					--build-arg DEPENDENCIES_IMAGE=$(REPO):32.1-tx2-jetpack-4.2-deps \
					-t $(REPO):$@ \
					-f $(CURDIR)/32.1/jax-tx2/Dockerfile \
					.

32.1-jax-tx2: 32.1-jax 32.1-tx2

32.1-nano-dev:
	$(DOCKER) build $(DOCKER_BUILD_ARGS) \
					--build-arg VERSION_ID="$(BIONIC_VERSION_ID)" \
					--build-arg DEPENDENCIES_IMAGE=$(REPO):32.1-nano-dev-jetpack-4.2-deps \
					-t $(REPO):$@ \
					-f $(CURDIR)/32.1/nano-dev/Dockerfile \
					.

