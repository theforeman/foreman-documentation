SHELL := /bin/bash
DEST := result
PORT := 5000
VERSION_LINKS := 3.19 3.18 3.17 3.16 3.15 3.14 3.13 3.12 3.11 3.10 3.9 3.8 3.7 3.6 3.5 3.4 3.3 3.2 3.1 3.0 2.5 2.4

.PHONY: all clean html web compile serve prep FORCE toc

UNAME = $(shell uname)
ifeq ($(UNAME), Linux)
CP_ARGS = -l
endif
ifeq ($(UNAME), Darwin)
CP_ARGS =
endif

all: html

prep:
	bundle config set path 'vendor'
	bundle install
	cd web && bundle config set path 'vendor' && bundle install
	mkdir -p $(DEST)/nightly

clean:
	$(MAKE) -C guides/ clean
	rm -rf $(DEST) web/output/

BUILDS = foreman-el foreman-deb containerized-katello containerized-orcharhino katello orcharhino satellite

html: FORCE prep
	@for b in $(BUILDS); do \
		$(MAKE) -C guides/ html BUILD=$$b || exit 1; \
	done

build-%: FORCE prep
	$(MAKE) -C guides/ html BUILD=$*

web: prep
	cd web && bundle exec nanoc

compile: web html
	cp $(CP_ARGS) -nr web/output/* $(DEST)
	cp $(CP_ARGS) -nr guides/build/* $(DEST)/nightly/
	for V in $(VERSION_LINKS); do ln -sf nightly $(DEST)/$$V; done

serve: compile
	python3 -m http.server --directory ./$(DEST) $(PORT)

toc: html
	$(MAKE) -C guides/ toc

FORCE:
