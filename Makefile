#
#  Makefile
#

export SHELL ?= /bin/bash
include make.cfg

CF_NAME := ${REGISTRY_URL}/${OWNER}/${PROJECT_NAME}
CF_VERSION = $(shell git describe --always --tags --dirty | sed 's/^v//' | sed 's/-g/-/')
CF_PLATFORMS ?= linux/amd64,linux/arm/v7,linux/arm64
CF_PATH ?= Containerfile

export DOCKER_CLI_EXPERIMENTAL = enabled

DOCKER ?= docker

default: build

.PHONY: help
help:
	@echo 'Management commands for $(PROJECT_NAME):'
	@grep -Eh '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
	 awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: check
check: ## Check/lint the init scripts
	shellcheck configs/init.sh

.PHONY: build
build: ## Build the image
	@echo "building ${CF_VERSION}"
	${DOCKER} info
	${DOCKER} build -f ${CF_PATH} --build-arg TARGETARCH=amd64 --build-arg TARGETOS=linux --pull -t ${CF_NAME}:${CF_VERSION} .

# build manifest for git describe
# manifest version is "1.2.3-23ab3df"
# image version is "1.2.3-23ab3df-amd64"

.PHONY: init-build
init-build:
	${DOCKER} context create build
	${DOCKER} buildx create --driver docker-container --name build --use build
	${DOCKER} buildx inspect --bootstrap
	${DOCKER} buildx ls

.PHONY: release-snapshot
release-snapshot: init-build
	@echo "building multi-arch image ${CF_VERSION}"
	${DOCKER} buildx build -f ${CF_PATH} --platform ${CF_PLATFORMS} --pull -t ${CF_NAME}:${CF_VERSION} --push .
	${DOCKER} context rm build

.PHONY: release
release: init-build ## Build a multi-arch manifest and images
	@echo "building multi-arch image ${CF_VERSION}"
	${DOCKER} buildx build -f ${CF_PATH} --platform ${CF_PLATFORMS} --pull -t ${CF_NAME}:${CF_VERSION} -t ${CF_NAME}:latest --push .
	${DOCKER} context rm build
