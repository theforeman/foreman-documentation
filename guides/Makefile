SHELL := /bin/bash
ALL_DIRS = $(wildcard doc-*)
ALL_GUIDES = $(patsubst doc-%,%,$(ALL_DIRS))
BUILDS=foreman-el foreman-deb katello
BUILD_DIR := build
COMMON_DIR := common
DEPENDENCIES := $(shell find $(COMMON_DIR) -type f -name \*.adoc)
DATE_MDY := $(shell LC_ALL=C date "+%b %d %Y")
DATE_MY := $(shell LC_ALL=C date "+%b %Y")

HTML_INDEXES := $(BUILDS:%=index-%.html)
PDFS := $(BUILDS:%=index-%.pdf)
GUIDE_BUILDS := $(addprefix $(BUILD_DIR)/,$(ALL_GUIDES))

GUIDES-HTML := $(foreach guide,$(GUIDE_BUILDS),$(addprefix $(guide)/,$(HTML_INDEXES)))
GUIDES-PDF := $(foreach guide,$(GUIDE_BUILDS),$(addprefix $(guide)/,$(PDFS)))

.PHONY: all html pdf linkchecker all-html all-pdf clean all-clean linkchecker-tryer

all: html

html: $(GUIDES-HTML)

pdf: $(GUIDES-PDF)

clean:
	rm -rf build

linkchecker:
	find $(BUILD_DIR) -type f -name index\*html | xargs linkchecker -r1 -f common/linkchecker.ini --check-extern

linkchecker-tryer:
	find $(BUILD_DIR) -type f -name index\*html | xargs linkchecker -r1 -f common/linkchecker.ini --check-extern | linkchecker-tryer

# The variables only work within rules
CURRENT_BUILD=$(patsubst index-%,%,$(notdir $(basename $@)))
CSS_FILE=$(COMMON_DIR)/$(CURRENT_BUILD).css

# TODO: copy images
#$(BUILD_DIR)/%/%.png:

# TODO: depend on .css file
$(addprefix $(BUILD_DIR)/%/,$(HTML_INDEXES)): doc-%/master.adoc $(wildcard doc-%/topics/*.adoc) $(DEPENDENCIES)
	@mkdir -p "$(@D)"
	asciidoctor -a build=$(CURRENT_BUILD) -a docinfo=shared -a date_mdy="$(DATE_MDY)" -a date_my="$(DATE_MY)" -a docdatetime="$(DATE_MY)" -a stylesheet=$(CSS_FILE) -a linkcss=true -b html5 -d book --trace -o $@ $< 2>&1 | tee $@.log
	@! grep -Eq "^asciidoctor: (ERROR|WARNING)" $@.log

$(addprefix $(BUILD_DIR)/%/,$(PDFS)): doc-%/master.adoc $(wildcard doc-%/topics/*.adoc) $(DEPENDENCIES)
	@mkdir -p "$(@D)"
	asciidoctor-pdf -a build=$(CURRENT_BUILD) -d book --trace -o $@ $< 2>&1 | tee $@.log
	@! grep -Eq "^asciidoctor: (ERROR|WARNING)" $@.log
