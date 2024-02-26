SHELL := /bin/bash
SUBDIRS = $(shell ls -d doc-*)

.PHONY: all clean html linkchecker linkchecker-tryer serve subdirs $(SUBDIRS)

all: html

html: subdirs

subdirs: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C "$@" $(MAKECMDGOALS)

clean:
	@for DIR in $(SUBDIRS) ; do \
		$(MAKE) -s --directory="$$DIR" clean ; \
	done

linkchecker:
	find build -type f -name index\*html | xargs linkchecker -r1 -f common/linkchecker.ini --check-extern

linkchecker-tryer:
	find build -type f -name index\*html | xargs linkchecker -r1 -f common/linkchecker.ini --check-extern | ./scripts/linkchecker-tryer

toc: html
	F2L=upstream_filename_to_link.json ruby scripts/extract_links_toc build/**/index-*.html > build/toc.json
