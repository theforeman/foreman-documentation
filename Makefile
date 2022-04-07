SHELL := /bin/bash
DEST := result
PORT := 5000
ifeq ($(LINKS), SERVE)
BASEURL := http://localhost:$(PORT)/
endif
VERSION_LINKS := 3.11 3.10 3.9 3.8 3.7 3.6 3.5 3.4 3.3 3.2 3.1 3.0 2.5 2.4
BRANCH = nightly
BASEPATH := $(BRANCH)/

.PHONY: all clean html web compile serve prep FORCE toc browse

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
	mkdir -p $(DEST)/$(BRANCH)

clean:
	$(MAKE) -C guides/ clean
	rm -rf $(DEST) web/output/

html: build-foreman-el build-foreman-deb build-katello

build-%: FORCE prep
	$(MAKE) -C guides/ html BUILD=$*

web: prep
	cd web && bundle exec nanoc

compile: web html
	cp $(CP_ARGS) -nr web/output/* $(DEST)
	cp $(CP_ARGS) -nr guides/build/* $(DEST)/$(BRANCH)/
	for V in $(VERSION_LINKS); do if [ ! -L $(DEST)/$$V ] ; then ln -snf $(BRANCH) $(DEST)/$$V; fi ; done

serve: compile
	python3 -m http.server --directory ./$(DEST) $(PORT)

toc: html
	$(MAKE) -C guides/ toc

FORCE:

browse:
	$(BROWSER_OPEN) $(BASEURL)
