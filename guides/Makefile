all: html

html: all-html

pdf: all-pdf

clean: all-clean

all-html:
	cd doc-Provisioning_Guide && $(MAKE) html
	cd doc-Monitoring_Guide && $(MAKE) html

all-pdf:
	cd doc-Provisioning_Guide && $(MAKE) pdf
	cd doc-Monitoring_Guide && $(MAKE) pdf

all-clean:
	cd doc-Provisioning_Guide && $(MAKE) clean
	cd doc-Monitoring_Guide && $(MAKE) clean
