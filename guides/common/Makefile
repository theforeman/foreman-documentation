SHELL := /bin/bash
BUILD = foreman-el
BUILD_DIR = ../build
COMMON_DIR = ../common
ROOTDIR = $(realpath .)
NAME = $(notdir $(ROOTDIR))
DEST_DIR = $(BUILD_DIR)/$(subst doc-,,$(NAME))
DEST_HTML = $(DEST_DIR)/index-$(BUILD).html
DEST_PDF = $(BUILD_DIR)/$(subst doc-,,$(NAME))-$(BUILD).pdf
IMAGES_DIR = $(DEST_DIR)/images
IMAGES_TS = $(DEST_DIR)/.timestamp-images
SOURCES = master.adoc $(shell find . -type f -name \*.adoc)
DEPENDENCIES = $(shell find $(COMMON_DIR) -type f -name \*.adoc)
IMAGES = $(shell find ./images ./common/images -type f 2>/dev/null || true)
UNAME = $(shell uname)
DATE_MDY = $(shell LC_ALL=C date "+%b %d %Y")
DATE_MY = $(shell LC_ALL=C date "+%b %Y")

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
	mkdir -p $(BUILD_DIR) $(DEST_DIR) $(IMAGES_DIR) $(IMAGES_DIR) $(DEST_DIR)/common/images

clean:
	@rm -rf "$(DEST_DIR)" "$(DEST_PDF)"

browser: html
	${BROWSER_OPEN} "file://$(realpath $(ROOTDIR)/$(DEST_HTML))"

linkchecker: html
	linkchecker -r1 -f $(COMMON_DIR)/linkchecker.ini --check-extern "file://$(realpath $(ROOTDIR)/$(DEST_HTML))"

open-pdf: pdf
	${BROWSER_OPEN} "$(realpath $(ROOTDIR)/$(DEST_PDF))"

$(DEST_DIR)/$(BUILD).css: $(COMMON_DIR)/$(BUILD).css
	cp $< $@

$(IMAGES_TS): $(IMAGES)
	cp $? $(IMAGES_DIR)/
	pushd "$(IMAGES_DIR)" && for IMG in *.*; do ln -s ../../images/$$IMG ../common/images/$$IMG; done && popd
	touch $(IMAGES_TS)

$(DEST_HTML): $(SOURCES) $(DEPENDENCIES)
	asciidoctor -a build=$(BUILD) -a docinfo=shared -a date_mdy="$(DATE_MDY)" -a date_my="$(DATE_MY)" -a docdatetime="$(DATE_MY)" -a stylesheet=$(BUILD).css -a linkcss=true -b html5 -d book --trace -o $@ $< 2>&1 | tee $@.log
	@! grep -Eq "^asciidoctor: (ERROR|WARNING)" $@.log

$(DEST_PDF): $(SOURCES) $(IMAGES) $(DEPENDENCIES)
	asciidoctor-pdf -a build=$(BUILD) -d book --trace -o $@ $< 2>&1 | tee $@.log
	@! grep -Eq "^asciidoctor: (ERROR|WARNING)" $@.log
