SHELL := /bin/bash
BUILD = foreman-el
BUILD_DIR = ../build
BUILD_DIRA = $(realpath $(BUILD_DIR))/
COMMON_DIR = ../common
ROOTDIR = $(realpath .)
NAME = $(notdir $(ROOTDIR))
DEST_DIR = $(BUILD_DIR)/$(subst doc-,,$(NAME))
DEST_HTML = $(DEST_DIR)/index-$(BUILD).html
DEST_PDF = $(BUILD_DIR)/$(subst doc-,,$(NAME))-$(BUILD).pdf
IMAGES_DIR = $(DEST_DIR)/images
IMAGES_TS = $(DEST_DIR)/.timestamp-images
CSS_SOURCES = $(shell find $(COMMON_DIR)/css -type f)
DOCINFO_SOURCES = $(shell find $(COMMON_DIR)/ -type f -name docinfo\*.html)
SOURCES = master.adoc $(shell find . -type f -name \*.adoc)
DEPENDENCIES = $(shell find $(COMMON_DIR) -type f -name \*.adoc)
IMAGES = $(shell find ./images ./common/images -type f 2>/dev/null || true)
UNAME = $(shell uname)
DATE_MDY = $(shell LC_ALL=C date "+%b %d %Y")
DATE_MY = $(shell LC_ALL=C date "+%b %Y")
CSS_STYLE = compressed

ifeq ($(UNAME), Linux)
BROWSER_OPEN = xdg-open
endif
ifeq ($(UNAME), Darwin)
BROWSER_OPEN = open
endif

ifeq ($(LINKS), LOCAL)
BASEURL_ATTR = "-a BaseURL=file://$(BUILD_DIRA)"
endif

all: html

prepare:
	@mkdir -p $(BUILD_DIR) $(DEST_DIR) $(IMAGES_DIR) $(IMAGES_DIR) $(DEST_DIR)/common/images

css: prepare $(DEST_DIR)/$(BUILD).css

html: css $(IMAGES_TS) $(DEST_HTML)

pdf: prepare $(DEST_PDF)

clean:
	@rm -rf "$(DEST_DIR)" "$(DEST_PDF)" "$(BUILD_DIR)/default.css"

browser: html
	${BROWSER_OPEN} "file://$(realpath $(ROOTDIR)/$(DEST_HTML))"

serve: html
	python -m http.server --directory "$(realpath $(DEST_DIR))" 8813

linkchecker: html
	linkchecker -r1 -f $(COMMON_DIR)/linkchecker.ini --check-extern "file://$(realpath $(ROOTDIR)/$(DEST_HTML))"

open-pdf: pdf
	${BROWSER_OPEN} "$(realpath $(ROOTDIR)/$(DEST_PDF))"

$(BUILD_DIR)/default.css: $(CSS_SOURCES)
	bundle exec sass -C --style $(CSS_STYLE) -I $(COMMON_DIR)/css $(COMMON_DIR)/css/default.scss $@

$(DEST_DIR)/$(BUILD).css: $(BUILD_DIR)/default.css
	cp $< $@

$(IMAGES_TS): $(IMAGES)
	cp $? $(IMAGES_DIR)/
	pushd "$(IMAGES_DIR)" >/dev/null && for IMG in *.*; do ln -fs ../../images/$$IMG ../common/images/$$IMG; done && popd >/dev/null
	@touch $(IMAGES_TS)

$(DEST_HTML): $(SOURCES) $(DEPENDENCIES) $(DOCINFO_SOURCES)
	bundle exec asciidoctor -a build=$(BUILD) $(BASEURL_ATTR) -a docinfo=shared -a docinfodir=common -a date_mdy="$(DATE_MDY)" -a date_my="$(DATE_MY)" -a docdatetime="$(DATE_MY)" -a stylesheet=$(BUILD).css -a linkcss=true -b html5 -d book --trace -o $@ $< 2>&1 | tee $@.log

$(DEST_PDF): $(SOURCES) $(IMAGES) $(DEPENDENCIES)
	bundle exec asciidoctor-pdf -a build=$(BUILD) -d book --trace -o $@ $< 2>&1 | tee $@.log
