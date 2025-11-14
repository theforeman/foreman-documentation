# Contributing to Foreman Documentation

If you need help to get started, open an issue, ask the docs team on [Matrix](https://matrix.to/#/#theforeman-doc:matrix.org), or ping [`@docs`](https://community.theforeman.org/g/docs) on the [Foreman Community Forum](https://community.theforeman.org/).

## Contributor's pledge

As a contributor, I will:

* Familiarize myself with the [Pull Request Checklist](#Pull-Request-Checklist) and [Foreman documentation conventions guide](#Foreman-documentation-conventions-guide).
* Open additional issues if my contribution is incomplete.
* Put in my best effort to ensure that my contribution does not worsen the state of any build target.
For example, this might include reviewing how my changes affect upstream build targets even when working on behalf of a downstream product.

## Maintainer's pledge

As a maintainer, I will:

* Help less experienced community members with git, Github, PRs, asciidoc, and asciidoctor and make friendly and helpful comments.
* Only merge PRs if the Github Actions are green.
* Try to review PRs in a timely manner.
* Keep non-trivial PRs open for at least 24 hours (72 hours if over the weekend) to allow for input from the community.
Examples of trivial PRs: Fixing a typo, fixing markup, or fixing links.
Non-trivial PRs might not only benefit from additional review but they also represent an opportunity for community members to ask questions and learn.

## Pull request checklists

Checklist for documentation contributions:

* [ ] My contribution is my own work and I agree to the license of the project.
See [LICENSE](LICENSE).
* [ ] My commits include meaningful commit messages.
See [seven rules for git commit messages](https://cbea.ms/git-commit/#seven-rules).
* [ ] My change does not add trailing whitespaces.
Some editors can help with this.
For example, VS Code has multiple settings related to handling whitespaces.

Checklist for raising PRs:

* [ ] I re-read my work carefully before raising a PR or before marking a draft PR as ready for review.
This can include using `git show`, viewing the diff against master or the target branch, running a local Vale check, and other methods.
* [ ] My PR description includes a meaningful description of the changes for the community.
* [ ] I fill out the cherry-picking list in the PR description to the best of my abilities to signify which versions my update applies to.
If unsure, I let reviewers know so that they can assist.
* [ ] Before pinging others about my PR, I await the GitHub Actions checks to see if my branch builds.
If a GitHub check fails and I'm unsure how to proceed, I let reviewers know so that they can assist.

Each PR should undergo tech review.
(Tech review is performed by an Engineer who did not author the PR. It can be skipped if the PR does not significantly change description of product behavior.)

* [ ] The PR documents a recommended, user-friendly path.
* [ ] The PR removes steps that have been made unnecessary or obsolete.
* [ ] Any steps introduced or updated in the PR have been tested to confirm that they lead to the documented end result.

Each PR should undergo style review.
(Style review is performed by a Technical Writer who did not author the PR.)

* [ ] The PR conforms with the team's style guidelines.
* [ ] The PR introduces documentation that describes a user story rather than a product feature.

## Foreman documentation conventions guide

The `Foreman documentation conventions guide` describes guidelines specific to working on Foreman documentation.
It complements, but should not duplicate, the following resources:

* The AsciiDoc, RedHat, and project-specific foreman-documentation style packages for the Vale linter.
See [Vale for writers at Red Hat](https://redhat-documentation.github.io/vale-at-red-hat/docs/main/user-guide/introduction/).
* [Red Hat supplementary style guide for product documentation](https://redhat-documentation.github.io/supplementary-style-guide/)

### Code conventions

Use the following markup conventions:

* Use UTF-8 character encoding in source files.
* Do not add trailing whitespace on lines and in files.
Some editors can help with this.
For example, VS Code has multiple settings related to handling whitespaces.
Whitespace after partial files has to be handled in the file using the `include::` directive.
* Surround user input with underscores (`_`) to indicate variable input, for example, `hammer organization create --name "_My_Organization_"`.

### Images

Each guide directory contains an `images/` subdirectory with `images/common` symlink into the `common/images/` directory.

* Save images local to the guide to the `images/` directory.
* Save images which are supposed to be reused across guides to the `images/common/` directory.

You can create upstream diagrams using [diagrams.net](https://www.diagrams.net/).
Place the editable diagram in `drawio` format in `guides/image-sources/`.
For inclusion in the content, export diagrams to SVG and place them as described above.

### AsciiDoc attributes for different build targets

Because the content in this repository is shared between the upstream Foreman community and branded downstream products, many terms need to be written using AsciiDoc attributes.
For example, never write "Foreman", "Satellite", or "orcharhino" words directly, but use the `{Project}` attribute.

The attributes used in this repository are defined in the following files:

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

### Conditional content

If a piece of your content, such as a block, paragraph, warning, or chapter, is specific for a certain build target, use AsciiDoc conditionals to show or hide it.

To show a piece of content only for the `katello` build:

	ifdef::katello[]
	NOTE: This part is only relevant for Foreman with the Katello plugin.
	endif::[]

To hide a piece of content for `katello` but show it for all other builds:

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
Their first line contains the `:_mod-docs-content-type: CONCEPT` attribute.
See the [concept template](https://raw.githubusercontent.com/redhat-documentation/modular-docs/master/modular-docs-manual/files/TEMPLATE_CONCEPT_concept-explanation.adoc).
* [`proc`](https://redhat-documentation.github.io/modular-docs/#creating-procedure-modules): Files starting with `proc_` contain procedures and explain _how_ to achieve a specific goal.
Their first line contains the `:_mod-docs-content-type: PROCEDURE` attribute.
See the [procedure template](https://raw.githubusercontent.com/redhat-documentation/modular-docs/master/modular-docs-manual/files/TEMPLATE_PROCEDURE_doing-one-procedure.adoc).
* [`ref`](https://redhat-documentation.github.io/modular-docs/#creating-reference-modules): Files starting with `ref_` contain references and append other files, for example tables with options.
Their first line contains the `:_mod-docs-content-type: REFERENCE` attribute.
See the [reference template](https://raw.githubusercontent.com/redhat-documentation/modular-docs/master/modular-docs-manual/files/TEMPLATE_REFERENCE_reference-material.adoc).
* [`snip`](https://redhat-documentation.github.io/modular-docs/#using_text_snippets_or_text_fragments_writing-mod-docs): Files starting with `snip_` contain snippets that are reused throughout multiple guides, for example admonitions.
Snippets must not contain an ID.

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

### Foreman user personas

In documentation, a user persona is the target user who will be reading the documentation.
Understanding and identifying the target persona of a piece of content helps ensure that the documentation will properly address the user's needs and capabilities.

Foreman users include people with varying responsibilities and permissions.
Especially in larger organizations, different tasks are performed by different teams.
Therefore, when contributing to Foreman documentation, it can be useful to be aware of and distinguish Foreman user personas.

#### *User* persona

* Has limited permissions
* Runs regular Foreman operations
* Example responsibilities: managing content, provisioning hosts, and managing hosts

#### *Admin* persona

* Has unlimited permissions, including root access to the Foreman Server
* Example responsibilities: managing Foreman server

#### *Architect* persona

* Has no permissions, does not perform practical administrative or management tasks
* Example responsibilities: determining whether Foreman/Katello meets the needs of their organization and planning the deployment

### Further Information

* [Contributing Guidelines for Github documentation](https://github.com/github/docs/blob/main/CONTRIBUTING.md)
* [theforeman.org/contribute](https://theforeman.org/contribute.html)
* [7 Git tips for technical writers](https://opensource.com/article/22/11/git-tips-technical-writers)
