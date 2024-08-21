SHELL := /bin/bash
DEST := web/output
PORT := 5000
ifeq ($(LINKS), SERVE)
BASEURL := http://localhost:$(PORT)/
endif
VERSION_LINKS := 3.11 3.10 3.9 3.8 3.7 3.6 3.5 3.4 3.3 3.2 3.1 3.0 2.5 2.4
BRANCH = nightly
BASEPATH := $(BRANCH)/

.PHONY: all clean html web compile serve serve-prep prep FORCE toc browse

UNAME = $(shell uname)
ifeq ($(UNAME), Linux)
BROWSER_OPEN = xdg-open
CP_ARGS = -l
endif
ifeq ($(UNAME), Darwin)
BROWSER_OPEN = open
CP_ARGS =
endif

all: html

prep:
	bundle install --path vendor
	cd web && bundle install --path ../vendor

clean:
	$(MAKE) -C guides/ clean
	rm -rf $(DEST)

html: build-foreman-el build-foreman-deb build-katello

build-%: FORCE prep
	$(MAKE) -C guides/ html BUILD=$*

web: prep
	cd web && bundle exec nanoc

serve-prep:
	ln -snf ../../guides/build web/output/$(BRANCH)
	for V in $(VERSION_LINKS); do if [ ! -e $(DEST)/$$V ] ; then ln -snf $(BRANCH) web/output/$$V ; fi ; done

serve: serve-prep
	cd web && bundle exec nanoc live --port=$(PORT)

toc: html
	$(MAKE) -C guides/ toc

FORCE:

browse:
	$(BROWSER_OPEN) $(BASEURL)
