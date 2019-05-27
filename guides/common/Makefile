DEST_DIR = ../$(BUILD_DIR)/$(NAME)
DEST_HTML = $(DEST_DIR)/index.html
DEST_PDF = ../$(BUILD_DIR)/$(NAME).pdf
IMAGES_DIR = $(DEST_DIR)/images
IMAGES_TS = $(DEST_DIR)/.timestamp-images
SOURCES = master.adoc $(shell ls topics/*.adoc)
IMAGES = $(shell find ./images -type f)

all: html pdf

html: prepare $(IMAGES_TS) $(DEST_HTML)

pdf: prepare $(DEST_PDF)

prepare:
	@mkdir -p $(DEST_DIR) $(IMAGES_DIR)

$(IMAGES_TS): $(IMAGES)
	cp -l $? $(IMAGES_DIR)
	touch $(IMAGES_TS)

$(DEST_HTML): $(SOURCES)
	asciidoctor -b xhtml5 -d book -o $@ $<

$(DEST_PDF): $(SOURCES) $(IMAGES)
	asciidoctor-pdf -d book -o $@ $<
