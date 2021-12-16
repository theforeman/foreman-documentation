SHELL := /bin/bash
ALL_DIRS = $(shell ls -d doc-*)
GUIDES-HTML = $(ALL_DIRS)

.PHONY: all html pdf linkchecker all-html all-pdf clean all-clean linkchecker-tryer $(GUIDES-HTML)

all: html

html: all-html

pdf: all-pdf

clean: all-clean

linkchecker:
	echo "do not check links"
	# find build -type f -name index\*html | xargs linkchecker -r1 -f common/linkchecker.ini --check-extern

linkchecker-tryer:
	echo "do not check links"
	# find build -type f -name index\*html | xargs linkchecker -r1 -f common/linkchecker.ini --check-extern | linkchecker-tryer

all-html: $(GUIDES-HTML)

$(GUIDES-HTML):
	$(MAKE) --directory=$@ html

all-pdf:
	for DIR in $(ALL_DIRS) ; do \
		$(MAKE) --directory="$$DIR" pdf ; \
	done

$(GUIDES-PDF):
	$(MAKE) --directory=$@ pdf

all-clean:
	for DIR in $(ALL_DIRS) ; do \
		$(MAKE) --directory="$$DIR" clean ; \
	done
