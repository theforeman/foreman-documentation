# Foreman guides

This is upstream source code of [Red Hat Satellite 6](https://access.redhat.com/documentation/en-us/red_hat_satellite) documentation as well as parts of the [orcharhino documentation](https://docs.orcharhino.com/or/docs/index.html).

This is **work in progress**, an attempt to take content written by Red Hat documentation team, modularize it, incorporate [Foreman Manuals](https://theforeman.org/manuals/), and eventually make this the only and official documentation for Foreman, Katello, and all plugins.

Contributions are welcome.
Please read the [Contribution guidelines](#contribution-guidelines) before opening a Pull Request.

## Building locally

### Installing tools

Install the required tools.

* In Fedora perform:

      dnf -y groupinstall development-tools
      dnf -y install ruby ruby-devel rubygem-bundler linkchecker

  Then continue to [install Ruby gems](#installing-ruby-gems).

* In RHEL perform:

      dnf module enable ruby:2.7
      dnf -y groupinstall "Development Tools"
      dnf -y install ruby ruby-devel rubygem-bundler python3-pip
      pip3 install linkchecker

  If you prefer to install Python packages into home folder rather than system-wide folder (requires root), then add `--user` option to the `pip3` command.
  Then continue to [install Ruby gems](#installing-ruby-gems).

* In MacOS, required tools can be installed via brew but instead of "make" call "gmake":

      brew install ruby make
      # brew will ask to perform this after ruby installation, do it and restart the terminal
      echo 'export PATH="/opt/homebrew/opt/ruby/bin:$PATH"' >> ~/.zshrc

  Alternatively, XCode development environment can be installed to have "make" utility available on PATH, however, this takes about an hour to download and install, and requires several gigabytes of HDD space:

      xcode-select --install

  Then continue to [install Ruby gems](#installing-ruby-gems).

### Installing Ruby gems

In the `foreman-documentation` folder, run:

	make prep

### Building HTML artifacts

Run `make` or `make html`, either in the `guides/` directory or in `doc-*/` subdirectories.
When you run "make" in `guides/`, it builds all guides.

To speed up the build process, make sure to use `-j` option. Ideally, set it to amount of cores plus one:

	make -j9

An alias is often useful:

	alias make="make -j$(nproc)"

The final artifacts can be found in the `./build` subdirectory.
Note that GNU Makefile tracks changes and only builds relevant artifacts.
To trigger a full rebuild, use `make clean` to delete the build directory and start over.

### Builds

There are the following builds:

- `make BUILD=foreman-el` - This builds guides for Foreman on Enterprise Linux (EL) without the Katello plugin.
This is the default build for `make html`.
- `make BUILD=foreman-deb` - This builds guides for Foreman on Debian/Ubuntu without the Katello plugin.
- `make BUILD=katello` - This builds guides for Foreman on EL with the Katello plugin.
- `make BUILD=satellite` - This builds a preview of guides for Satellite.
- `make BUILD=orcharhino` - This builds a preview of guides for orcharhino.

### Building a single guide

Few additional make targets are available on the guide level.
To quickly build HTML version and open new tab in a browser do:

	cd doc-Provisioning_Hosts
	make browser

### Checking links

It's also possible to check links; the following command will check all links except example.com domain:

	make linkchecker

#### Disabling the linkchecker for a specific URL pattern

You can disable the linkcheck job for specific URL pattern, for example for unreleased downstream documentation or to exclude URLs that cannot resolve by design.
Append your pattern to `guides/common/linkchecker.ini`.
Example: [64d825cc9](https://github.com/theforeman/foreman-documentation/commit/64d825cc9da3992879dfbfc088988197edc9f33b)

### Building locally by using a container

You can build Foreman documentation locally using a container image.
This requires the cloned git repository plus an application such as Podman or Docker to build and run container images.

1. Build container image:

       podman build --tag foreman_documentation .

2. Build Foreman documentation.
   Run this command in your `foreman-documentation` repository:

       rm -rf guides/build && podman run --rm -v $(pwd):/foreman-documentation foreman_documentation make html

   On SELinux enabled systems, run this command:

       rm -rf guides/build && podman run --rm -v $(pwd):/foreman-documentation:Z foreman_documentation make html


## Generating a TOC file

For properly testing link integrity in the code, you will need to generate a TOC file.
This file can be generated using `make toc` command either from a container or locally.

This command generates a JSON file that later can be consumed by link validation code.
The basic structure of the file is a nested path parts in the documentation links. For example:
``` json
{
  "administering_red_hat_satellite": {
    "accessing_server_admin": [
      "Logging_in_admin",
      "Using_FreeIPA_credentials_to_log_in_to_the_foreman_Hammer_CLI_admin",
      "Using_FreeIPA_credentials_to_log_in_to_the_foreman_web_UI-with-Mozilla-Firefox_admin",
      "Using_FreeIPA_credentials_to_log_in_to_the_foreman_web_UI-with-a-Chrome-browser_admin",
      "Navigation_Tabs_in_the_Web_UI_admin",
      "Changing_the_Password_admin",
      "Resetting_the_Administrative_User_Password_admin",
      "Setting_a_Custom_Message_on_the_Login_Page_admin"
    ],
  }
}
```
which can be used for validating `administering_red_hat_satellite/accessing_server_admin#Logging_in_admin` link.

Note: The translation of book file names to root part of the link path is dependent on [`upstream_filename_to_satellite_link.json`](./upstream_filename_to_satellite_link.json) file.
For example `build/Administering_Project/index-satellite.html` would be translated to `.../administering_red_hat_satellite/...` path in the TOC.
File names that are missing from this JSON file would be omitted from the TOC.

Currently the main use of the TOC file is for downstream links validation in [`foreman_theme_satellite`](https://github.com/RedHatSatellite/foreman_theme_satellite/commit/7fb213daa8929b1e5ceb7999a79dbc8eebd3500d).
In order to implement the same technique for the upstream documentation, there is need to extract links from the code.

## Contribution guidelines

Please read these guidelines before opening a Pull Request.
For more information, see [Guidelines for Red Hat Documentation](https://redhat-documentation.github.io/).

New contributions are subject to technical review for accuracy and editorial review for consistency.
For an overview of what to expect from editorial review, see [Red Hat peer review guide for technical documentation](https://redhat-documentation.github.io/peer-review/#checklist).

If you need help to get started, open an issue, ask the docs team on [Matrix](https://matrix.to/#/#theforeman-doc:matrix.org), or ping [`@docs`](https://community.theforeman.org/g/docs) on the [Foreman Community Forum](https://community.theforeman.org/).

If you are unsure into which guide you should place your content, have a look at the `docinfo.xml` files within each `doc-*` directory.

### Code conventions

Use the following markup conventions:

* Source files use UTF-8 character encoding.
* Source files use [AsciiDoc](https://docs.asciidoctor.org/asciidoc/latest/) syntax and aim to follow [AsciiDoc Mark-up Conventions for Red Hat Documentation](https://redhat-documentation.github.io/asciidoc-markup-conventions/).
* A single line only contains one sentence.
Please do not wrap lines by hand.
This makes `git diff` much easier to read and helps when reviewing changes.
* No trailing whitespace on lines and in files.
Whitespace after partial files has to be handled in the file using the `include::` directive.
* Image file names use dashes (`-`) and suffix a build target, e.g. `foreman`.
See also [Images](#Images).
* User input is surrounded by underscores (`_`) to indicate variable input, e.g. `hammer organization create --name "_My Organization_" --label "_my_organization_"`.
* Links to different guides are followed by the title of the guide in italics, for example `in _{ManagingHostsDocTitle}_`.

### Images

Each guide must have an `images/` subdirectory with `images/common` symlink into the `common/images/` directory.
Images local to the guide shall be kept in the `images/` directory.
Images which are supposed to be reused across guides shall be kept in the `images/common/` directory.
Subdirectories can be created and are actually recommended.

To insert an image, use `image::common/global_image.png` or `image::local_image.png`.

You should create upstream diagrams using [diagrams.net](https://www.diagrams.net/).
Place the editable diagram in `drawio` format in `guides/image-sources/`.
For inclusion in the content, export diagrams to SVG and place them as described above.

### Using AsciiDoc attributes

The content in this repository is shared between the upstream Foreman community and branded downstream products such as Red Hat Satellite and orcharhino by ATIX.
Therefore, never write "Foreman", "Satellite", or "orcharhino" words directly, but use the following attributes:

| Attribute | Upstream value | Downstream by Red Hat | Downstream by ATIX |
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

By default, attributes cannot be used in shell or code examples.
To use them, use the "attributes" keyword:

	[options="nowrap" subs="+quotes,attributes"]
	----
	# ls {AttributeName}
	----

Avoid using phrases like "Starting from version 6.5 or 1.22" because it is not possible to easily translate these strings into all build variants.

#### Conditional content

If a piece of your content, such as a block, paragraph, warning, or chapter, is specific for a certain [build](#builds), use special build attributes to show or hide it.

To show a piece of content only for the `katello` build:

	ifdef::katello[]
	NOTE: This part is only relevant for Foreman with the Katello plugin.
	endif::[]

To hide a piece of content for `katello` that will be shown for all other builds:

	ifndef::katello[]
	NOTE: This part is relevant for Foreman without the Katello plugin, but also Satellite and orcharhino.
	endif::[]

Use comma for logic "or":

	ifdef::katello,satellite[]
	NOTE: This part is only relevant for deployments with Katello plugin or in Satellite environment.
	endif::[]

Some files are included in different contexts, there are attributes to find the correct context.
In these cases use both `ifdef` and `ifeval`:

	ifdef::foreman-el,foreman-deb[]
	ifeval::["{context}" == "{project-context}"]
	* A minimum of 4 GB RAM is required for {ProjectServer} to function.
	endif::[]
	endif::[]


### File structure

If you create a new file, use the file structure described here.

Documentation in this directory follows a modular structure described in the [Modular documentation reference guide](https://redhat-documentation.github.io/modular-docs/).
To write new documentation, you can use [modular documentation templates](https://github.com/redhat-documentation/modular-docs/tree/main/modular-docs-manual/files) or copy an existing file from `guides/common/modules/` and adapt it.

Included files are kept in the `common/` subdirectory and have prefixes to distinguish their type of content.

Assemblies are kept at the top of the `common/` subdirectory:

* [`assembly`](https://redhat-documentation.github.io/modular-docs/#forming-assemblies): Files starting with `assembly_` contain user stories and the modules required to accomplish those user stories.
See the [assembly template](https://raw.githubusercontent.com/redhat-documentation/modular-docs/master/modular-docs-manual/files/TEMPLATE_ASSEMBLY_a-collection-of-modules.adoc).

Modules are kept in the `common/modules/` subdirectory:

* [`con`](https://redhat-documentation.github.io/modular-docs/#creating-concept-modules): Files starting with `con_` contain concepts and explain the _what_ and _why_.
See the [concept template](https://raw.githubusercontent.com/redhat-documentation/modular-docs/master/modular-docs-manual/files/TEMPLATE_CONCEPT_concept-explanation.adoc).
* [`proc`](https://redhat-documentation.github.io/modular-docs/#creating-procedure-modules): Files starting with `proc_` contain procedures and explain _how_ to achieve a specific goal.
See the [procedure template](https://raw.githubusercontent.com/redhat-documentation/modular-docs/master/modular-docs-manual/files/TEMPLATE_PROCEDURE_doing-one-procedure.adoc).
* [`ref`](https://redhat-documentation.github.io/modular-docs/#creating-reference-modules): Files starting with `ref_` contain references and append other files, e.g. tables with options.
See the [reference template](https://raw.githubusercontent.com/redhat-documentation/modular-docs/master/modular-docs-manual/files/TEMPLATE_REFERENCE_reference-material.adoc).
* [`snip`](https://redhat-documentation.github.io/modular-docs/#using_text_snippets_or_text_fragments_writing-mod-docs): Files starting with `snip_` contain snippets that are reused throughout multiple guides, e.g. admonitions.
Snippets do not require an ID.

### Creating new guides

Each guide must be in a separate directory in `guides/` prefixed with `doc-`.
The following requirements must be met:

* Top-level file `master.adoc`.
* Symlink `common` to `../common` for shared content.
* Directory `images` with images.
* Symlink `images/common` to `../common/images`.
* File `Makefile` which includes `../common/Makefile`.
* File `docinfo.xml` for Red Hat Satellite guides.
Presence of this file will cause build check via `ccutil`, a tool used by Red Hat documentation team.
* Put new content into the `guides/common/modules` directory and stick to one (level one) heading per file.
* Update `web/content/js/nav.js` to add a new item on the top-level menu.

New guides can typically be created as copies of existing guides, just make sure to clean images, topics and `docinfo.xml`.
