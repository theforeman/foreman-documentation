SHELL := /bin/bash
ALL_DIRS = $(wildcard doc-*)
ALL_GUIDES = $(patsubst doc-%,%,$(ALL_DIRS))
BUILDS = foreman-deb foreman-el katello satellite orcharhino
BUILD_DIR := build
COMMON_DIR := common
DEPENDENCIES := $(shell find $(COMMON_DIR) -type f -name \*.adoc)
DATE_MDY := $(shell LC_ALL=C date "+%b %d %Y")
DATE_MY := $(shell LC_ALL=C date "+%b %Y")

HTMLS := $(BUILDS:%=%.html)
PDFS := $(BUILDS:%=%.pdf)
GUIDE_BUILDS := $(addprefix $(BUILD_DIR)/,$(ALL_GUIDES))

GUIDES-HTML := $(foreach guide,$(GUIDE_BUILDS),$(addprefix $(guide)/,$(HTMLS)))
GUIDES-PDF := $(foreach guide,$(GUIDE_BUILDS),$(addprefix $(guide)/,$(PDFS)))

.PHONY: all html pdf clean linkchecker linkchecker-tryer

all: html

html: $(GUIDES-HTML)

pdf: $(GUIDES-PDF)

clean:
	rm -rf $(BUILD_DIR)

linkchecker:
	find $(BUILD_DIR) -type f -name \*.html | xargs linkchecker -r1 -f common/linkchecker.ini --check-extern

linkchecker-tryer:
	find $(BUILD_DIR) -type f -name \*.html | xargs linkchecker -r1 -f common/linkchecker.ini --check-extern | linkchecker-tryer

# TODO: copy images
#$(BUILD_DIR)/%/%.png:

# TODO: combining the build rules into one appear to break
# It only executes one per run rather than all. Multiple runs does work

$(BUILD_DIR)/%/foreman-deb.html: doc-%/master.adoc $(wildcard doc-%/topics/*.adoc) $(COMMON_DIR)/foreman-deb.css $(DEPENDENCIES)
	@mkdir -p "$(@D)"
	asciidoctor -a build=$(notdir $(basename $@)) -a stylesheet=$(COMMON_DIR)/$(notdir $(basename $@)).css -a docinfo=shared -a date_mdy="$(DATE_MDY)" -a date_my="$(DATE_MY)" -a docdatetime="$(DATE_MY)" -a linkcss=true -b html5 -d book --trace -o $@ $< 2>&1 | tee $@.log
	@! grep -Eq "^asciidoctor: (ERROR|WARNING)" $@.log

$(BUILD_DIR)/%/foreman-el.html: doc-%/master.adoc $(wildcard doc-%/topics/*.adoc) $(COMMON_DIR)/foreman-el.css $(DEPENDENCIES)
	@mkdir -p "$(@D)"
	asciidoctor -a build=$(notdir $(basename $@)) -a stylesheet=$(COMMON_DIR)/$(notdir $(basename $@)).css -a docinfo=shared -a date_mdy="$(DATE_MDY)" -a date_my="$(DATE_MY)" -a docdatetime="$(DATE_MY)" -a linkcss=true -b html5 -d book --trace -o $@ $< 2>&1 | tee $@.log
	@! grep -Eq "^asciidoctor: (ERROR|WARNING)" $@.log

$(BUILD_DIR)/%/katello.html: doc-%/master.adoc $(wildcard doc-%/topics/*.adoc) $(COMMON_DIR)/katello.css $(DEPENDENCIES)
	@mkdir -p "$(@D)"
	asciidoctor -a build=$(notdir $(basename $@)) -a stylesheet=$(COMMON_DIR)/$(notdir $(basename $@)).css -a docinfo=shared -a date_mdy="$(DATE_MDY)" -a date_my="$(DATE_MY)" -a docdatetime="$(DATE_MY)" -a linkcss=true -b html5 -d book --trace -o $@ $< 2>&1 | tee $@.log
	@! grep -Eq "^asciidoctor: (ERROR|WARNING)" $@.log

$(BUILD_DIR)/%/satellite.html: doc-%/master.adoc $(wildcard doc-%/topics/*.adoc) $(COMMON_DIR)/satellite.css $(DEPENDENCIES)
	@mkdir -p "$(@D)"
	asciidoctor -a build=$(notdir $(basename $@)) -a stylesheet=$(COMMON_DIR)/$(notdir $(basename $@)).css -a docinfo=shared -a date_mdy="$(DATE_MDY)" -a date_my="$(DATE_MY)" -a docdatetime="$(DATE_MY)" -a linkcss=true -b html5 -d book --trace -o $@ $< 2>&1 | tee $@.log
	@! grep -Eq "^asciidoctor: (ERROR|WARNING)" $@.log

$(BUILD_DIR)/%/orcharhino.html: doc-%/master.adoc $(wildcard doc-%/topics/*.adoc) $(COMMON_DIR)/orcharhino.css $(DEPENDENCIES)
	@mkdir -p "$(@D)"
	asciidoctor -a build=$(notdir $(basename $@)) -a stylesheet=$(COMMON_DIR)/$(notdir $(basename $@)).css -a docinfo=shared -a date_mdy="$(DATE_MDY)" -a date_my="$(DATE_MY)" -a docdatetime="$(DATE_MY)" -a linkcss=true -b html5 -d book --trace -o $@ $< 2>&1 | tee $@.log
	@! grep -Eq "^asciidoctor: (ERROR|WARNING)" $@.log

$(BUILD_DIR)/%/foreman-deb.pdf: doc-%/master.adoc $(wildcard doc-%/topics/*.adoc) $(DEPENDENCIES)
	@mkdir -p "$(@D)"
	asciidoctor-pdf -a build=$(notdir $(basename $@)) -d book --trace -o $@ $< 2>&1 | tee $@.log
	@! grep -Eq "^asciidoctor: (ERROR|WARNING)" $@.log

$(BUILD_DIR)/%/foreman-el.pdf: doc-%/master.adoc $(wildcard doc-%/topics/*.adoc) $(DEPENDENCIES)
	@mkdir -p "$(@D)"
	asciidoctor-pdf -a build=$(notdir $(basename $@)) -d book --trace -o $@ $< 2>&1 | tee $@.log
	@! grep -Eq "^asciidoctor: (ERROR|WARNING)" $@.log

$(BUILD_DIR)/%/katello.pdf: doc-%/master.adoc $(wildcard doc-%/topics/*.adoc) $(DEPENDENCIES)
	@mkdir -p "$(@D)"
	asciidoctor-pdf -a build=$(notdir $(basename $@)) -d book --trace -o $@ $< 2>&1 | tee $@.log
	@! grep -Eq "^asciidoctor: (ERROR|WARNING)" $@.log

$(BUILD_DIR)/%/satellite.pdf: doc-%/master.adoc $(wildcard doc-%/topics/*.adoc) $(DEPENDENCIES)
	@mkdir -p "$(@D)"
	asciidoctor-pdf -a build=$(notdir $(basename $@)) -d book --trace -o $@ $< 2>&1 | tee $@.log
	@! grep -Eq "^asciidoctor: (ERROR|WARNING)" $@.log

$(BUILD_DIR)/%/orcharhino.pdf: doc-%/master.adoc $(wildcard doc-%/topics/*.adoc) $(DEPENDENCIES)
	@mkdir -p "$(@D)"
	asciidoctor-pdf -a build=$(notdir $(basename $@)) -d book --trace -o $@ $< 2>&1 | tee $@.log
	@! grep -Eq "^asciidoctor: (ERROR|WARNING)" $@.log
