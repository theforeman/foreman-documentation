# Foreman Guides

This is upstream source code of [Red Hat Satellite 6](https://access.redhat.com/documentation/en-us/red_hat_satellite) documentation as well as parts of the [orcharhino documentation](https://docs.orcharhino.com/or/docs/index.html).
All content in this repository uses [AsciiDoctor](https://asciidoctor.org/) syntax and aims to follow [Guidelines for Red Hat Documentation](https://redhat-documentation.github.io/).
This is a **work in progress**, an attempt to take content written by Red Hat documentation team, modularize it, incorporate [existing documentation](https://theforeman.org/documentation.html) and eventually make this the only and official documentation for Foreman, Katello and all plugins.

Contributions are welcome. Please read the [Contribution guidelines](#contribution-guidelines) before opening a Pull Request.

## Building Locally

Install the required tools.
In Fedora perform:

	dnf -y groupinstall development-tools
	dnf -y install ruby ruby-devel rubygem-bundler linkchecker

Then continue with the `make prep` step below.

In RHEL perform:
	
	dnf module enable ruby:2.7
	dnf -y groupinstall development-tools
	dnf -y install ruby ruby-devel rubygem-bundler python3-pip
	pip3 install linkchecker

If you prefer to install python packages into home folder rather than system-wide folder (requires root), then add `--user` option to the `pip3` command.
Then continue with the `make prep` step below.

In MacOS required tools can be installed via brew but instead "make" call "gmake":

	brew install ruby make
	# brew will ask to perform this after ruby installation, do it and restart the terminal
	echo 'export PATH="/opt/homebrew/opt/ruby/bin:$PATH"' >> ~/.zshrc

Alternatively, XCode development environment can be installed to have make utility available on PATH, however, this takes about an hour to download and install and requires several gigabytes of HDD space:

	xcode-select --install

Install ruby gems, in the `foreman-documentation` folder:

	make prep

Then simply run `make` or `make html` which builds HTML artifacts.
Generating PDF output is slow, therefore command `make pdf` must be used separately.
To make both formats in one command, use `make html pdf`.

Few additional make targets are available on the guide level.
To quickly build HTML version and open new tab in a browser do:

	cd doc-Provisioning_Guide
	make browser

Similarly, to build and open PDF version do:

	make open-pdf

To speed up the build process, make sure to use `-j` option. Ideally, set it to amount of cores plus one:

	make -j9

An alias is often useful:

	alias make="make -j$(nproc)"

Currently there are three different versions:


`make BUILD=foreman-el` - This is the default that is generated with `make html` or `pdf`.

`make BUILD=satellite` - This generates a downstream preview of the guide.

`make BUILD=katello` - this generates a katello build of the guide

`make BUILD=foreman-deb` - This generates a version for Foreman installed on Debian.

`make BUILD=orcharhino` - This generates a downstream preview of the guide for orcharhino.

The final artifacts can be found in the ./build subdirectory.
Note that GNU Makefile tracks changes and only builds relevant artifacts, to trigger full rebuild use `make clean` to delete build directory and start over.

It's also possible to check links; the following command will check all links except example.com domain:

	make linkchecker

## Building Locally Using a Container

You can build Foreman documentation locally using a container image.
This requires the cloned git repository plus an application such as Podman or Docker to build and run container images.

1. Build container image:

	podman build --tag foreman_documentation .

2. Build Foreman documentation.
   Run this command in your `foreman-documentation` repository:

	rm -rf guides/build && podman run --rm -v $(pwd):/foreman-documentation foreman_documentation make html

   On SELinux enabled systems, run this command:

	rm -rf guides/build && podman run --rm -v $(pwd):/foreman-documentation:Z foreman_documentation make html

## Reading or Publishing

We do not publish the content yet to prevent users confusion, however this section will cover steps required to publish the content.
We should make sure that only the last stable version of the HTML document is indexed by search engines, old and nightly builds should not be indexed.
All PDFs should be available for download though.

## Disabling the linkchecker for a specific URL pattern

You can disable the linkcheck job for specific URL pattern, for example for unreleased downstream documentation or to exclude URLs that cannot resolve by design.
Append your pattern to `guides/common/linkchecker.ini`.
Example: [64d825cc9](https://github.com/theforeman/foreman-documentation/commit/64d825cc9da3992879dfbfc088988197edc9f33b)

## Contribution guidelines

Please read these guidelines before opening a Pull Request. For more information, see [Guidelines for Red Hat Documentation](https://redhat-documentation.github.io/).

### Creating new guides

Each guide must be in a separate directory in guides/ prefixed with "doc-". The following requirements must be met:

* Top-level file `master.adoc`.
* Directory `topics` with actual content.
* Symlink `common` to `../common` for shared content.
* Directory `images` with images.
* Symlink `images/common` to `../common/images`.
* File `Makefile` which includes `../common/Makefile`.
* File `docinfo.xml` for downstream (Red Hat) guides. Presence of this file will cause build check via `ccutil`, a tool used by Red Hat documentation team.
* Put new content into the `guides/common/modules` directory and stick to one (level one) heading per file.
* Update `web/content/js/nav.js` to add a new item on the top-level menu.

New guides can be typically created as copies of existing guides, just make sure to clean images, topics and `docinfo.xml`.

### Variables

The content in this repository is shared between the upstream Foreman community and branded downstream products such as Red Hat Satellite and orcharhino by ATIX.
Therefore, never write "Foreman", "Satellite", or "orcharhino" words directly, but use the following variables:

| Variable | Upstream value | Downstream by Red Hat | Downstream by ATIX |
| -------- | -------------- | --------------------- | ------------------ |
| {Project} | Foreman | Satellite | orcharhino |
| {ProjectName} | Foreman | Red Hat Satellite | orcharhino |
| {ProjectServer} | Foreman server | Satellite Server | orcharhino server |
| {SmartProxy} | Smart Proxy | Capsule | orcharhino Proxy |
| {SmartProxyServer} | Smart Proxy server | Capsule Server | orcharhino Proxy |

Every build uses common base attributes, more are defined in the build specific attribute files:

* [attributes.adoc](common/attributes.adoc): version definitions and includes for other attribute files.
* [attributes-base.adoc](common/attributes-base.adoc): base attributes common for all builds.
* [attributes-foreman-el.adoc](common/attributes-foreman-el.adoc): base overrides for foreman-el build.
* [attributes-foreman-deb.adoc](common/attributes-foreman-deb.adoc): base overrides for foreman-deb build.
* [attributes-katello.adoc](common/attributes-katello.adoc): base overrides for katello build.
* [attributes-satellite.adoc](common/attributes-satellite.adoc): base overrides for satellite build.
* [attributes-orcharhino.adoc](common/attributes-orcharhino.adoc): base overrides for orcharhino build.

By default, variables cannot be used in shell or code examples.
To use them, use "attributes" keyword:

	[options="nowrap" subs="+quotes,attributes"]
	----
	# ls {VariableName}
	----

Hide or show specific blocks, paragraphs, warnings or chapters via special variable called "build".
Its value can be set either to "foreman-el" or "satellite":

	ifeval::["{build}" == "katello"]
	NOTE: This part is only relevant for deployments with Katello plugin.
	endif::[]

This syntax does not allow multiple conditionals, in that case use, now preferred, `ifdef` syntax:

	ifdef::katello[]
	NOTE: This part is only relevant for deployments with Katello plugin.
	endif::[]

Use comma for logic "or":

	ifdef::katello,satellite[]
	NOTE: This part is only relevant for deployments with Katello plugin or in Satellite environment.
	endif::[]

Some files are included in different contexts, there are attributes to find the correct context. In these cases use both `ifdef` and `ifeval`:

	ifdef::foreman-el,foreman-deb[]
	ifeval::["{context}" == "{project-context}"]
	* A minimum of 4 GB RAM is required for {ProjectServer} to function.
	endif::[]
	endif::[]

When doing review, consider checking out the topic branch and putting necessary changes on top of author's work to making many comments on github.

Avoid using phrases like "Starting from version 6.5 or 1.22" because it is not possible to easily translate these strings into all streams.

### Conventions

Use the following markup conventions:

* User input is surrounded by underscores (`_`) to indicate variable input, e.g. `hammer organization create --name "_My Organization_" --label "_my_organization_"`.
* A single line only contains one sentence.
Please do not wrap lines by hand.
This makes `git diff` much easier to read and helps reviewing changes.
* No trailing whitespace on lines and in files.
Whitespace after partial files has to be handled in the file using the `include::` directive.
* Source files use UTF-8 character encoding.
* Image file names use dashes (`-`) and suffix a build target, e.g. `foreman`.

### Structure

If you create a new file, use the file structure described here.

Files that are included in more than one guide are kept in the common/ subdirectory, and have prefixes to distinguish their type of content.

Assemblies are kept at the top of the common/ subdirectory:

* [`assembly`](https://redhat-documentation.github.io/modular-docs/#forming-assemblies): Files starting with `assembly_` contain user stories and the modules required to accomplish those user stories.
See the [assembly template](https://raw.githubusercontent.com/redhat-documentation/modular-docs/master/modular-docs-manual/files/TEMPLATE_ASSEMBLY_a-collection-of-modules.adoc).

Modules are kept in the common/modules/ subdirectory:

* [`con`](https://redhat-documentation.github.io/modular-docs/#creating-concept-modules): Files starting with `con_` contain concepts and explain the _what_ and _why_.
See the [concept template](https://raw.githubusercontent.com/redhat-documentation/modular-docs/master/modular-docs-manual/files/TEMPLATE_CONCEPT_concept-explanation.adoc).
* [`proc`](https://redhat-documentation.github.io/modular-docs/#creating-procedure-modules): Files starting with `proc_` contain procedures and explain _how_ to achieve a specific goal.
See the [procedure template](https://raw.githubusercontent.com/redhat-documentation/modular-docs/master/modular-docs-manual/files/TEMPLATE_PROCEDURE_doing-one-procedure.adoc).
* [`ref`](https://redhat-documentation.github.io/modular-docs/#creating-reference-modules): Files starting with `ref_` contain references and append other files, e.g. tables with options.
See the [reference template](https://raw.githubusercontent.com/redhat-documentation/modular-docs/master/modular-docs-manual/files/TEMPLATE_REFERENCE_reference-material.adoc).
* [`snip`](https://redhat-documentation.github.io/modular-docs/#using_text_snippets_or_text_fragments_writing-mod-docs): Files starting with `snip_` contain snippets that are reused throughout multiple guides, e.g. admonitions.
Snippets do not require an ID.

### Images

Each guide must have an `images/` subdirectory with `images/common` symlink into the `common/images` directory.
Images local to the guide shall be kept in the `images/` directory.
Images which are supposed to be reused across guides shall be kept in the `images/common` directory.
Subdirectories can be created and are actually recommended.
To insert an image, use `image::common/global_image.png` or `image::local_image.png`.

For more information, see the [Modular Documentation Reference Guide](https://redhat-documentation.github.io/modular-docs/).
