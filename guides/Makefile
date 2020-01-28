SHELL=/bin/bash
GUIDES=doc-Provisioning_Guide doc-Installing_Capsule_Server doc-Installing_Satellite_Server_Connected doc-Installing_Satellite_Server_Disconnected

all: html

html: all-html

pdf: all-pdf

linkchecker: all-linkchecker

clean: all-clean

all-html:
	for DIR in $(GUIDES) ; do \
		pushd "$$DIR" ; \
		$(MAKE) html ; \
		popd ; \
	done

all-pdf:
	for DIR in $(GUIDES) ; do \
		pushd "$$DIR" ; \
		$(MAKE) pdf ; \
		popd ; \
	done

all-linkchecker:
	for DIR in $(GUIDES) ; do \
		pushd "$$DIR" ; \
		$(MAKE) linkchecker ; \
		popd ; \
	done

all-clean:
	for DIR in $(GUIDES) ; do \
		pushd "$$DIR" ; \
		$(MAKE) clean ; \
		popd ; \
	done
