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
# The Satellite build uses links which do not resolve. This does mean the link
# checker has issues with verification of guides that have not yet been built
# by downstream, but there really isn't a way around this unless we start
# building with downstream filenames.
ifneq ($(BUILD), satellite)
BASEURL_ATTR = -a "BaseURL=file://$(BUILD_DIRA)"
endif
endif

.SHELLFLAGS = -o pipefail -c
.PHONY = all prepare html pdf clean browser server linkchecker open-pdf

all: html

prepare:
	@mkdir -p $(BUILD_DIR) $(DEST_DIR) $(IMAGES_DIR) $(DEST_DIR)/sass-cache

html: prepare $(IMAGES_TS) $(DEST_HTML)

pdf: prepare $(DEST_PDF)

clean:
	@rm -rf "$(DEST_DIR)" "$(DEST_PDF)"

browser: html
	${BROWSER_OPEN} "file://$(realpath $(ROOTDIR)/$(DEST_HTML))"

serve: html
	python -m http.server --directory "$(realpath $(DEST_DIR))" 8813

linkchecker: html
	linkchecker -r1 -f $(COMMON_DIR)/linkchecker.ini --check-extern "file://$(realpath $(ROOTDIR)/$(DEST_HTML))"

open-pdf: pdf
	${BROWSER_OPEN} "$(realpath $(ROOTDIR)/$(DEST_PDF))"

$(DEST_DIR)/$(BUILD).css: $(CSS_SOURCES)
	bundle exec sass --sourcemap=none --cache-location $(DEST_DIR)/sass-cache --style $(CSS_STYLE) -I $(COMMON_DIR)/css $(COMMON_DIR)/css/default.scss $@

$(IMAGES_TS): $(IMAGES)
	@[[ -h ./images/common ]] || echo "FAILURE: Missing ./images dir with ./images/common symlink to commons!"
	cp -lLrf ./images/* $(IMAGES_DIR)
	@touch $(IMAGES_TS)

$(DEST_HTML): $(SOURCES) $(DEPENDENCIES) $(DOCINFO_SOURCES) $(DEST_DIR)/$(BUILD).css $(IMAGES_TS)
	bundle exec asciidoctor -a build=$(BUILD) $(BASEURL_ATTR) -a docinfo=shared -a docinfodir=common -a date_mdy="$(DATE_MDY)" -a date_my="$(DATE_MY)" -a docdatetime="$(DATE_MY)" -a stylesheet=$(DEST_DIR)/$(BUILD).css -a attribute-missing=warn -b html5 -d book --trace -o $@ $< 2>&1 | tee $@.log 1>&2
	@echo CHECKING FOR ASCIIDOCTOR ERRORS AND WARNINGS
	@! grep -Eq "^asciidoctor: (ERROR|WARNING)" $@.log
	@echo CHECKING FOR ORPHAN XREFS HTML LINKS
	@! grep -RE '<a href="#[a-zA-Z0-9_-]+">\[[a-zA-Z0-9_-]+\]</a>' $@

$(DEST_PDF): $(SOURCES) $(DEPENDENCIES)
	bundle exec asciidoctor-pdf -a build=$(BUILD) -a imagesdir=./images -d book --trace -o $@ $< 2>&1 | tee $@.log 1>&2
	@echo CHECKING FOR ASCIIDOCTOR-PDF ERRORS AND WARNINGS
	@! grep -Eq "^asciidoctor: (ERROR|WARNING)" $@.log
