SHELL := /bin/bash
GUIDES = $(shell ls -d doc-*)

all: html

html: all-html

pdf: all-pdf

linkchecker: all-linkchecker

clean: all-clean

all-html:
	for DIR in $(GUIDES) ; do \
		pushd "$$DIR" && \
		$(MAKE) html && \
		popd ; \
	done

all-pdf:
	for DIR in $(GUIDES) ; do \
		pushd "$$DIR" && \
		$(MAKE) pdf && \
		popd ; \
	done

all-linkchecker:
	for DIR in $(GUIDES) ; do \
		pushd "$$DIR" && \
		$(MAKE) linkchecker && \
		popd ; \
	done

all-clean:
	for DIR in $(GUIDES) ; do \
		pushd "$$DIR" && \
		$(MAKE) clean && \
		popd ; \
	done
