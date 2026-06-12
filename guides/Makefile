SHELL := /bin/bash
# All doc- directories except doc-Contributing (which has separate build system)
SUBDIRS = $(shell ls -d doc-* | grep -v 'doc-Contributing')
CONTRIBUTING_DIR = doc-Contributing

.PHONY: all clean html linkchecker linkchecker-tryer serve subdirs $(SUBDIRS) contributing

all: html

html: subdirs contributing

subdirs: $(SUBDIRS)

contributing:
	@if [ -d "$(CONTRIBUTING_DIR)" ]; then \
		$(MAKE) -C "$(CONTRIBUTING_DIR)" html; \
	fi

$(SUBDIRS):
	$(MAKE) -C "$@" $(MAKECMDGOALS)

clean:
	@for DIR in $(SUBDIRS) ; do \
		$(MAKE) -s --directory="$$DIR" clean ; \
	done
	@if [ -d "$(CONTRIBUTING_DIR)" ]; then \
		$(MAKE) -s --directory="$(CONTRIBUTING_DIR)" clean ; \
	fi

linkchecker:
	find build -type f -name index\*html | xargs linkchecker -r1 -f common/linkchecker.ini --check-extern

linkchecker-tryer:
	find build -type f -name index\*html | xargs linkchecker --no-warnings -r1 -f common/linkchecker.ini --check-extern | ./scripts/linkchecker-tryer

ccutil: $(SUBDIRS)

toc:
	make BUILD=satellite html
	F2L=upstream_filename_to_satellite_link.json ./scripts/extract_links_toc build/**/index-satellite.html > build/toc.json
