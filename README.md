# Foreman documentation

This Git repository contains the following documentation:

* Official documentation for the Katello project
* PoC of improving documentation for the Foreman project. See [this milestone](https://github.com/theforeman/foreman-documentation/milestone/3) to check the progress.

For official Foreman documentation, see [Foreman Manual](https://theforeman.org/manuals/latest/index.html).

Foreman community welcomes all feedback, issues, pull requests (PRs), and reviews.
Every contributor has different backgrounds, interests, and experiences with Foreman and its open source community.

We give ourselves these guidelines to collaborate and contribute to Foreman documentation more efficiently.
It helps everyone to set expectations, communicate conventions, and ensures happy collaborative work across organizations and backgrounds.
We respect each others time and energy spent on Foreman documentation.

Familiarize yourself with [CONTRIBUTING](CONTRIBUTING.md) before you start contributing.

## Repository contents

### `web/` subdirectory

The landing page for [docs.theforeman.org](https://docs.theforeman.org) is available as a generated static site.
The static content is always built from the `master` branch.
See [README in the `web/` subdirectory](web/README.md) for more information, including information on locally testing the site.

### `guides/` subdirectory

The sources for documentation are available as AsciiDoc files.
The guides are based on the [modular documentation framework](https://redhat-documentation.github.io/modular-docs/).
See the [README in the `guides/` subdirectory](guides/README.md) for more information, including instructions on locally building individual guides.

### Global `Makefile` to build both static side and guides

To build both the static site and the guides for easy local testing, a global `Makefile` is provided in the root directory with the following targets:

* `html`: builds HTML guides with all contexts (`foreman-el`, `foreman-deb`, `katello`, `satellite`, and `orcharhino`)
* `web`: builds static site using the `nanoc` tool
* `compile`: compiles all content into a single directory `./result`
* `serve`: serves the result directory via a python web server (the default target)

To use the `Makefile`, you must first install the `gcc`, `gcc-c++`, and `ruby-devel` packages.
Then, to test the entire site locally, perform `make serve` command and open up `http://localhost:5000`.
Use `PORT=5008` to change the web server port (5000 by default).
This builds all contexts, so the initial build might be slow. 
For faster builds on modern multi-core machines, use the `-j` option.
Stable versions are symlinks to the nightly (current) version, which can cause issues for deleted (or renamed) guides.

### `.vale` subdirectory

This repository uses the [Vale](https://vale.sh/) linter.
The `.vale/styles/` subdirectory includes a project-specific `foreman-documentation` style package with rules to check for Foreman documentation project conventions.
When adding a new rule to the `foreman-documentation` style, make sure it does not duplicate the other styles included in `.vale/styles/`.

## Deployment

GitHub actions perform HTML (with link validation) and WEB artifact creation and if succeeded and branch is master or stable, artifacts are downloaded, extracted and deployed (commited into gh-pages). Deployment does not delete files, in order to remove some unwanted content, manual deletion and push into gh-pages must be performed.

When a commit is pushed into `master`:

* All artifacts are built.
* Static WEB and HTML is downloaded and copied into `/` or `/nightly` respectively.
* Changes are pushed into `gh-pages` branch.

When a commit is pushed into `X.Y`:

* All artifacts are built.
* HTML artifact is downloaded and copied into `/X.Y`.
* Changes are pushed into `gh-pages` branch.

## Branching a new release

When a new Foreman version is branched, the Foreman release owner ensures that a new branch for documentation is created.

* On `master`, pull the latest changes and create a new `X.Y` branch.
* On the `X.Y` branch:
  * Update `guides/common/attributes.adoc`.
    * Set `DocState` to `RC`.
    * Set `ProjectVersion` to `X.Y` and set the matching `KatelloVersion`.
  * Push into the `X.Y` branch.
  * Notify the Doc team on the [TheForeman Doc chat](https://matrix.to/#/#theforeman-doc:matrix.org) Matrix channel.
* On `master`:
  * Update `ProjectVersionPrevious` to `X.Y` in `guides/common/attributes.adoc`.
  * Create a copy of [/web/releases/nightly.json](https://github.com/theforeman/foreman-documentation/tree/master/web/releases/nightly.json) as `X.Y.json` and edit it accordingly.
    * Set the `state` to `RC`.
    * Change `katello` to the right version.
    * Change `Nightly` in titles to the appropriate version.
    * Remove guides which aren't ready for stable branches.
  * Test the changes by following the instructions in [/web/README.md](https://github.com/theforeman/foreman-documentation/tree/master/web/README.md) to deploy the website locally.
  * Add the new Foreman version to [/.github/PULL_REQUEST_TEMPLATE.md](https://github.com/theforeman/foreman-documentation/blob/master/.github/PULL_REQUEST_TEMPLATE.md).
  * Update `VERSION_LINKS` in the root `Makefile`.
  * Push the changes into `master`.
* Check the site if links and landing page appeared correctly. HTML guides should be deployed into `/X.Y`.

## License

See LICENSE files in the respective subdirectories.
