# Genesis OS - Samsung Galaxy J6 (j6lte)
# Top-level build coordinator

SHELL       := /bin/bash
VERSION     ?= $(shell date +%Y%m%d)
DEVICE      := j6lte
OUT         := $(CURDIR)/out
SCRIPTS     := $(CURDIR)/build-scripts

.PHONY: all kernel rootfs debloat launcher package clean help

all: kernel rootfs debloat launcher package

## Build the privacy-hardened kernel for Exynos 7870 / j6lte
kernel:
	@echo "==> Building Genesis kernel for $(DEVICE)..."
	@bash $(SCRIPTS)/build_kernel.sh

## Fetch LineageOS sources and assemble a minimal AOSP rootfs
rootfs:
	@echo "==> Building rootfs for $(DEVICE)..."
	@bash $(SCRIPTS)/build_rootfs.sh

## Strip trackers, telemetry, and bloatware from the assembled rootfs
debloat:
	@echo "==> Removing bloatware and trackers..."
	@bash $(SCRIPTS)/debloat.sh

## Bundle the Genesis-Mobile PWA as the system home launcher
launcher:
	@echo "==> Bundling Genesis-Mobile launcher..."
	@bash $(SCRIPTS)/bundle_launcher.sh

## Package everything into a flashable ZIP
package:
	@echo "==> Packaging Genesis OS $(VERSION) for $(DEVICE)..."
	@mkdir -p $(OUT)
	@if [ -d $(OUT)/system ]; then \
		zip -r $(OUT)/genesis-os-$(DEVICE)-$(VERSION).zip $(OUT)/system; \
		echo "==> Output: $(OUT)/genesis-os-$(DEVICE)-$(VERSION).zip"; \
	else \
		echo "ERROR: $(OUT)/system not found — run 'make rootfs' first."; \
		exit 1; \
	fi

## Remove build output
clean:
	@echo "==> Cleaning build output..."
	@rm -rf $(OUT)

## Show this help
help:
	@echo ""
	@echo "Genesis OS build system — Samsung Galaxy J6 ($(DEVICE))"
	@echo ""
	@echo "Targets:"
	@grep -E '^##' Makefile | sed 's/^## /  /'
	@echo ""
	@echo "Variables:"
	@echo "  VERSION=$(VERSION)   (override with VERSION=x.y)"
	@echo ""
