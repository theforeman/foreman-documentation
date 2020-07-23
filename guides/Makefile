SHELL := /bin/bash
GUIDES = $(shell ls -d doc-*)

all: html

html: all-html

pdf: all-pdf

clean: all-clean

linkchecker:
	find build -type f -name index\*html | xargs linkchecker -r1 -f common/linkchecker.ini --check-extern

linkchecker-tryer:
	find build -type f -name index\*html | xargs linkchecker -r1 -f common/linkchecker.ini --check-extern | linkchecker-tryer

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
