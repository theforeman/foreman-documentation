# Foreman Guides

This is upstream source code of [Red Hat Satellite 6](https://access.redhat.com/documentation/en-us/red_hat_satellite) documentation. All content in this repository uses [AsciiDoctor](https://asciidoctor.org/) syntax and aims to follow [Guidelines for Red Hat Documentation](https://redhat-documentation.github.io/). This is a **work in progress*, an attempt to take content written by Red Hat documentation team, modularize it, incorporate [existing documentation](https://theforeman.org/documentation.html) and eventually make this the only and official documentation for Foreman, Katello and all plugins.

## Building

Install required tools:

    dnf -y install ruby asciidoctor asciidoctor-pdf make

If AsciiDoctor is not available in repositories or under RVM/rbenv, simply install it from rubygems:

  	gem install asciidoctor asciidoctor-pdf --pre

Then simply run `make` or `make html` which builds HTML artifacts. Generating PDF output is slow, therefore command `make pdf` must be used separately. To make both formats in one command, use `make html pdf`. To build downstream version perform `make BUILD=satellite`.

The final artifacts can be found in the ./build subdirectory. Note that GNU Makefile tracks changes and only builds relevant artifacts, to trigger full rebuild use `make clean` to delete build directory and start over.

## Reading or Publishing

We do not publish the content yet to prevent users confusion, however this section will cover steps required to publish the content. We should make sure that only the last stable version of the HTML document is indexed by search engines, old and nightly builds should not be indexed. All PDFs should be available for download tho.

## Contributing

Please read [Guidelines for Red Hat Documentation](https://redhat-documentation.github.io/) before opening a Pull Request. Additional rules apply:

Never write "Foreman" or "Satellite" words directly but use the following variables:

| Variable | Upstream value | Downstream value |
| -------- | -------------- | ---------------- |
| {ProjectNameXY} | Foreman 1.22 | Red Hat Satellite 6.5 |
| {ProjectNameX} | Foreman | Red Hat Satellite 6 |
| {ProjectName} | Foreman | Red Hat Satellite |
| {ProjectXY} | Foreman 1.22 | Satellite 6.5 |
| {ProjectX} | Foreman | Satellite 6 |
| {Project} | Foreman | Satellite |
| {SmartProxyServer} | Smart Proxy server | Capsule Server |
| {SmartProxy} | Smart Proxy | Capsule |

Variables cannot be used in shell or code examples. To use them, use "attributes" keyword:

	[options="nowrap" subs="+quotes,+attributes"]
	----
	# ls {VariableName}
	----

Hide or show specific blocks, paragraphs, warnings or chapters via special variable called "build". Its value can be set either to "foreman" or "satellite":

	ifeval::["{build}" == "foreman"]
	NOTE: This part is only relevant for deployments with Katello plugin.
	endif::[]

When doing review, consider checking out the topic branch and putting necessary changes on top of author's work to making many comments on github.

## The process (TODO)

This is what we are working on right now:

* [x] Initial import of Provisioning Guide
* [x] Provide Makefiles and Travis integration
* [x] Replace Satellite 6 with Foreman term
* [ ] Modularize content
* [ ] Hide irrelevant chapters
* [ ] Incorporate parts from upstream docs
* [ ] Incorporate https://community.theforeman.org/t/discovery-ipxe-efi-workflow-in-foreman-1-20/13026
* [ ] Write better introduction
* [ ] Add Anaconda-image based provisioning workflow
* [ ] Update with PXE Grub2 steps
* [ ] Discuss with Foreman community if to continue with other guides
