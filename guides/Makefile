BUILD_DIR = build

all: html

html: provisioning-html

pdf: provisioning-pdf

prepare:
	@mkdir -p $(BUILD_DIR)

clean:
	@rm -rf $(BUILD_DIR)

provisioning-html: prepare
	cd doc-Provisioning_Guide && $(MAKE) html BUILD_DIR=$(BUILD_DIR) NAME=Provisioning_Guide
provisioning-pdf: prepare
	cd doc-Provisioning_Guide && $(MAKE) pdf BUILD_DIR=$(BUILD_DIR) NAME=Provisioning_Guide
