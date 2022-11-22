SHELL := /bin/bash
SUBDIRS = $(shell ls -d doc-*)

.PHONY: all clean html pdf linkchecker linkchecker-tryer serve subdirs $(SUBDIRS)

all: html

html: subdirs

pdf: subdirs

subdirs: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C "$@" $(MAKECMDGOALS)

clean:
	@for DIR in $(SUBDIRS) ; do \
		$(MAKE) -s --directory="$$DIR" clean ; \
	done

linkchecker:
	find build -type f -name index\*html | xargs linkchecker -r1 -f common/linkchecker.ini --check-extern

serve:
	python -m http.server --directory ./build 8813

linkchecker-tryer:
	find build -type f -name index\*html | xargs linkchecker -r1 -f common/linkchecker.ini --check-extern | ./scripts/linkchecker-tryer
