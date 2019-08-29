BUILD = foreman
BUILD_DIR = ../build
ROOTDIR = $(realpath .)
NAME = $(notdir $(ROOTDIR))
DEST_DIR = $(BUILD_DIR)/$(NAME)
DEST_HTML = $(DEST_DIR)/index-$(BUILD).html
DEST_PDF = $(BUILD_DIR)/$(NAME)-$(BUILD).pdf
IMAGES_DIR = $(DEST_DIR)/images
IMAGES_TS = $(DEST_DIR)/.timestamp-images
SOURCES = master.adoc $(shell ls topics/*.adoc)
IMAGES = $(shell find ./images -type f)

all: html

html: prepare $(IMAGES_TS) $(DEST_HTML)

pdf: prepare $(DEST_PDF)

prepare:
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(DEST_DIR) $(IMAGES_DIR)

clean:
	@rm -rf "$(DEST_DIR)" "$(DEST_PDF)"

browser: html
	$(BROWSER) "file://$(realpath $(ROOTDIR)/$(DEST_HTML))"

open-pdf: pdf
	xdg-open "$(realpath $(ROOTDIR)/$(DEST_PDF))"

$(IMAGES_TS): $(IMAGES)
	cp -l $? $(IMAGES_DIR)
	touch $(IMAGES_TS)

$(DEST_HTML): $(SOURCES)
	asciidoctor -a build=$(BUILD) -b xhtml5 -d book -o $@ $<

$(DEST_PDF): $(SOURCES) $(IMAGES)
	asciidoctor-pdf -a build=$(BUILD) -d book -o $@ $<
