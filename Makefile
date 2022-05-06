SHELL := /bin/bash
DEST := result
PORT := 5000
VERSION_LINKS := 3.3 3.2 3.1 3.0 2.5 2.4

.PHONY: all clean html web compile serve

UNAME = $(shell uname)
ifeq ($(UNAME), Linux)
CP_ARGS = -l
endif
ifeq ($(UNAME), Darwin)
CP_ARGS =
endif

all: serve

prep:
	mkdir -p $(DEST)/nightly

clean:
	$(MAKE) -C guides/ clean
	rm -rf $(DEST) web/output/

html: prep
	$(MAKE) -C guides/ html BUILD=foreman-el
	$(MAKE) -C guides/ html BUILD=foreman-deb
	$(MAKE) -C guides/ html BUILD=katello

web: prep
	cd web && bundle exec nanoc

compile: web html
	cp $(CP_ARGS) -nr web/output/* $(DEST)
	cp $(CP_ARGS) -nr guides/build/* $(DEST)/nightly/
	for V in $(VERSION_LINKS); do ln -sf nightly $(DEST)/$$V; done

serve: compile
	python3 -m http.server --directory ./$(DEST) $(PORT)
