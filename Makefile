REGISTRY=ghcr.io/ev-smoke
IMAGE_NAME=example

PLATFORMS := linux darwin windows
ARCHS := amd64 arm64

SRC_DIR := ./
DOCKER_TAG := latest

UNAME_S := $(shell uname -s)
UNAME_M := $(shell uname -m)

ifeq ($(origin PLATFORM), undefined)
	ifeq ($(UNAME_S),Linux)
		PLATFORM := linux
	else ifeq ($(UNAME_S),Darwin)
		PLATFORM := darwin
	else
		$(error Unsupported host platform: $(UNAME_S))
	endif
endif

ifeq ($(origin ARCH), undefined)
	ifeq ($(UNAME_M),x86_64)
		ARCH := amd64
	else ifeq ($(UNAME_M),arm64)
		ARCH := arm64
	else
		$(error Unsupported host arch: $(UNAME_M))
	endif
endif


build:
	@echo "Building for $(PLATFORM)/$(ARCH) ..."
	@$(MAKE) build-$(PLATFORM) ARCH=$(ARCH)

build-linux:
	@echo ">>> [Linux] Compiling for $(ARCH)"
	@cd $(SRC_DIR) && CGO_ENABLED=0 GOOS=linux GOARCH=$(ARCH) go build -o app .

build-windows:
	@echo ">>> [Windows] Compiling for $(ARCH)"
	@cd $(SRC_DIR) && CGO_ENABLED=0 GOOS=windows GOARCH=$(ARCH) go build -o app.exe .

build-darwin:
	@echo ">>> [macOS] Compiling for $(ARCH)"
	@cd $(SRC_DIR) && CGO_ENABLED=0 GOOS=darwin GOARCH=$(ARCH) go build -o app .

define MAKE_PLATFORM_ARCH_RULE
$(1)_$(2):
	@$(MAKE) build PLATFORM=$(1) ARCH=$(2)
endef

$(foreach platform,$(PLATFORMS), \
	$(foreach arch,$(ARCHS), \
		$(eval $(call MAKE_PLATFORM_ARCH_RULE,$(platform),$(arch))) \
	) \
)

image:
	@echo "=== Building Docker image for $(PLATFORM)/$(ARCH) ==="
	@DOCKER_BUILDKIT=1 docker buildx build \
		--platform $(PLATFORM)/$(ARCH) \
		--file Dockerfile \
		--tag $(REGISTRY)/$(IMAGE_NAME):$(PLATFORM)-$(ARCH)-$(DOCKER_TAG) \
		--build-arg PLATFORM=$(PLATFORM) \
		--build-arg ARCH=$(ARCH) \
		--output type=docker . > /dev/null 2>&1 ; \


clean:
	@rm -rf app* >/dev/null 2>&1 || true
	@docker rmi -f $(shell docker images '${REGISTRY}/${IMAGE_NAME}' --format "{{.ID}}") >/dev/null 2>&1 || true

help:
	@echo "Make OS/ARCH targets:"
	@echo "make linux_amd64            - make linux/amd64"
	@echo "make linux_arm64            - make linux/arm64"
	@echo "make darwin_amd64           - make macOS/amd64"
	@echo "make darwin_arm64           - make macOS/arm64"
	@echo "make windows_arm64          - make windows/arm64"
	@echo
	@echo "make image                  - build Docker image for current host platform"
	@echo "make image PLATFORM=darwin ARCH=arm64"
