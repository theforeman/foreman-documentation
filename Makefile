SHELL := /bin/bash
MAKEFLAGS += -j
DEST := result
PORT := 5000
VALE_IMAGE ?= docker.io/jdkato/vale
VALE_FILES ?= guides/common
VALE_FLAGS ?= --minAlertLevel=error
VERSION_LINKS := 5.0 3.19 3.18 3.17 3.16 3.15 3.14 3.13 3.12 3.11 3.10 3.9 3.8 3.7 3.6 3.5 3.4 3.3 3.2 3.1 3.0 2.5 2.4

.PHONY: all clean html web compile serve prep vale vale-all FORCE toc css

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

vale-all:
	podman run --rm --userns=keep-id -v "$(CURDIR):/work:Z" -w /work --entrypoint /bin/sh $(VALE_IMAGE) -c 'vale sync && vale --config=.vale.ini $(VALE_FLAGS) $(VALE_FILES)'

vale:
	@changed_files="$$(scripts/changed-files.py)"; \
	if [ -z "$$changed_files" ]; then echo "No changed AsciiDoc files to lint."; exit 0; fi; \
	podman run --rm --userns=keep-id -v "$(CURDIR):/work:Z" -w /work --entrypoint /bin/sh $(VALE_IMAGE) -c "vale sync && vale --config=.vale.ini $(VALE_FLAGS) $$changed_files"

clean:
	$(MAKE) -C guides/ clean
	rm -rf $(DEST) web/output/

html: build-foreman-el build-foreman-deb build-containerized-katello build-containerized-orcharhino build-katello build-orcharhino build-satellite

# Built once, up front, and shared by every build-% below: the compiled CSS
# does not vary by BUILD, and compiling it redundantly from N parallel
# build-% processes races on the same output file.
css: prep
	$(MAKE) -j -C guides/ css

build-%: FORCE css
	$(MAKE) -C guides/ html BUILD=$*

web: prep
	cd web && bundle exec nanoc

compile: web html
	cp $(CP_ARGS) -nr web/output/* $(DEST)
	cp $(CP_ARGS) -nr guides/build/* $(DEST)/nightly/
	for V in $(VERSION_LINKS); do ln -sf nightly $(DEST)/$$V; done

serve:
	python3 -m http.server --directory ./$(DEST) $(PORT)

toc: html
	$(MAKE) -C guides/ toc

FORCE:
