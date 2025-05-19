REGISTRY=ghcr.io/ev-smoke
IMAGE_NAME=your_name

PLATFORMS := linux darwin windows
ARCHS := amd64 arm64

PLATFORM ?= linux
ARCH ?= amd64

SRC_DIR := ./
DOCKER_TAG := latest

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
	@for arch in $(ARCHS); do \
		echo "=== Building Docker image for $(PLATFORM)/$$arch ==="; \
		docker buildx build \
			--platform $(PLATFORM)/$$arch \
			--file Dockerfile \
			--tag $(REGISTRY)/$(IMAGE_NAME):$(PLATFORM)-$$arch-$(DOCKER_TAG) \
			--build-arg PLATFORM=$(PLATFORM) \
			--build-arg ARCH=$$arch \
			--output type=docker .; \
	done


clean:
	@docker rmi -f $(shell docker images '${REGISTRY}/${IMAGE_NAME}' --format "{{.ID}}") >/dev/null 2>&1 || true

help:
	@echo "Make OS/ARCH targets:"
	@echo "make linux_amd64						- make linux/amd64"
	@echo "make linux_arm64						- make linux/arm64"
	@echo "make darwin_amd64					- make macOS/amd64"
	@echo "make darwin_arm64					- make macOS/arm64"
	@echo "make windows_arm64					- make windows/arm64"
	@echo "make image							- make docker images for all platform/arch"
