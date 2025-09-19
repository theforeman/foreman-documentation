# Contributing to Foreman Documentation

## Contributor's pledge

As a contributor, I will:

* Familiarize myself with the [Pull Request Checklist](#Pull-Request-Checklist) and [Foreman documentation minimalist style guide](#Foreman-documentation-minimalist-style-guide).
* Open additional issues if my contribution is incomplete.

## Maintainer's pledge

As a maintainer, I will:

* Help less experienced community members with git, Github, PRs, asciidoc, and asciidoctor and make friendly and helpful comments.
* Only merge PRs if the Github Actions are green.
* Try to review PRs in a timely manner.
* Keep non-trivial PRs open for at least 24 hours (72 hours if over the weekend) to allow for input from the community.
Examples of trivial PRs: Fixing a typo, fixing markup, or fixing links.
Non-trivial PRs might not only benefit from additional review but they also represent an opportunity for community members to ask questions and learn.

## Pull request checklist

* [ ] Before pushing, I view my diff against master or the target branch and check for spelling mistakes, failed conflict resolutions, etc.
* [ ] Before pinging others about my PR, I await the Github Actions to see if my branch builds.
* [ ] If I add text that applies only to a specific downstream product, I notify others and give them a chance to request extending the `ifdef::[]` or `ifndef::[]` directive.
+ [ ] My change does not contain `Foreman`, `Satellite`, or `orcharhino`.
Instead, I use attributes.
* [ ] I don't add useless or trailing white space.
* [ ] I put each sentence to its own line.
* [ ] I write a meaningful commit message.
See [seven rules for git commit messages](https://cbea.ms/git-commit/#seven-rules).
* [ ] My change does not worsen the state of any build target.
* [ ] My contribution is my own work and I agree to the license of the project.
See [LICENSE](LICENSE).
* [ ] If I make more than one change on my branch, I create more than one commit and rebase my branch to master.
* [ ] My PR does not solely rely on internal resources to answer the _why_, but instead contains at least a basic description for the community.
* [ ] When creating my PR, I select all branches I want my change to get cherry-picked to.
* [ ] I am familiar to proper capitalization for project-specific terminology.
See [Capitalization](#Capitalization).
* [ ] The first line of the file contains the modular docs content type attribute, for example, `:_mod-docs-content-type: ASSEMBLY` for assemblies.
* [ ] I fill out the cherry-picking list in the PR template to the best of my abilities to signify which versions my update applies to.
If unsure, I let reviewers know so that they can assist.

## Foreman documentation minimalist style guide

### Contribution guidelines

If you need help to get started, open an issue, ask the docs team on [Matrix](https://matrix.to/#/#theforeman-doc:matrix.org), or ping [`@docs`](https://community.theforeman.org/g/docs) on the [Foreman Community Forum](https://community.theforeman.org/).

### Code conventions

Use the following markup conventions:

* Source files use UTF-8 character encoding.
* Source files use [AsciiDoc](https://docs.asciidoctor.org/asciidoc/latest/) syntax.
* A single line only contains one sentence.
Please do not wrap lines by hand.
This makes `git diff` much easier to read and helps when reviewing changes.
* No trailing whitespace on lines and in files.
Whitespace after partial files has to be handled in the file using the `include::` directive.
* Image file names use dashes (`-`) and suffix a build target, for example, `foreman`.
See also [Images](#Images).
* User input is surrounded by underscores (`_`) to indicate variable input, for example, `hammer organization create --name "_My Organization_" --label "_my_organization_"`.
* Links to different guides are followed by the title of the guide in italics, for example `in _{ManagingHostsDocTitle}_`.
* The first line of a file contains the modular docs content type attribute, for example, `:_mod-docs-content-type: ASSEMBLY` for assemblies.
The content type reflects the file prefix: `ASSEMBLY`, `PROCEDURE`, `CONCEPT`, or `REFERENCE`.
The only exceptions are `master.adoc` files, which do not require this attribute.

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

### Capitalization

All headings are sentence case.
We capitalize the following terms:

* Ansible
* Ansible Playbook
* Candlepin
* Chef
* Deb (content type)
* Discovery (service)
* Enterprise Linux (umbrella term for RHEL-derivatives)
* Hammer
* Insights (Red Hat product)
* Katello
* Kickstart
* Library (environment)
* OpenSCAP
* PostgreSQL
* Pulp
* Puppet
* Python
* Red Hat Network
* Redis
* Salt
* Salt Minions
* Secure Boot
* Subscription Manager (Red Hat product)
* Tracer (utility)
* Yum (content type)

We do not capitalize the following terms:

* content view
* lifecycle environment
* manifest
* Red Hat subscription manifest
* remote execution
* subscription

### Further Information

* [Contributing Guidelines for Github documentation](https://github.com/github/docs/blob/main/CONTRIBUTING.md)
* [theforeman.org/contribute](https://theforeman.org/contribute.html)
* [7 Git tips for technical writers](https://opensource.com/article/22/11/git-tips-technical-writers)
