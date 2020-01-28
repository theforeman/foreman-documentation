BUILD = foreman
BUILD_DIR = ../build
COMMON_DIR = ../common
ROOTDIR = $(realpath .)
NAME = $(notdir $(ROOTDIR))
DEST_DIR = $(BUILD_DIR)/$(NAME)
DEST_HTML = $(DEST_DIR)/index-$(BUILD).html
DEST_PDF = $(BUILD_DIR)/$(NAME)-$(BUILD).pdf
IMAGES_DIR = $(DEST_DIR)/images
IMAGES_TS = $(DEST_DIR)/.timestamp-images
SOURCES = master.adoc $(shell find . -type f -name \*.adoc)
IMAGES = $(shell find ./images ./common/images -type f 2>/dev/null || true)
UNAME = $(shell uname)

ifeq ($(UNAME), Linux)
BROWSER_OPEN = xdg-open
endif
ifeq ($(UNAME), Darwin)
BROWSER_OPEN = open
endif

all: html

html: prepare $(DEST_DIR)/$(BUILD).css $(IMAGES_TS) $(DEST_HTML)

pdf: prepare $(DEST_PDF)

prepare:
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(DEST_DIR) $(IMAGES_DIR)

clean:
	@rm -rf "$(DEST_DIR)" "$(DEST_PDF)"

browser: html
	${BROWSER_OPEN} "file://$(realpath $(ROOTDIR)/$(DEST_HTML))"

linkchecker: html
	linkchecker -vr1 --check-extern --ignore-url=example.com "file://$(realpath $(ROOTDIR)/$(DEST_HTML))"

open-pdf: pdf
	${BROWSER_OPEN} "$(realpath $(ROOTDIR)/$(DEST_PDF))"

$(DEST_DIR)/$(BUILD).css: $(COMMON_DIR)/$(BUILD).css
	cp $< $@

$(IMAGES_TS): $(IMAGES)
	cp $? $(IMAGES_DIR)
	touch $(IMAGES_TS)

$(DEST_HTML): $(SOURCES)
	asciidoctor -a build=$(BUILD) -a stylesheet=$(BUILD).css -a linkcss=true -b html5 -d book --trace -o $@ $<

$(DEST_PDF): $(SOURCES) $(IMAGES)
	asciidoctor-pdf -a build=$(BUILD) -d book --trace -o $@ $<
