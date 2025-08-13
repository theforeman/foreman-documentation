# Foreman documentation

This Git repository contains the following documentation:

* Official documentation for the Katello project
* PoC of improving documentation for the Foreman project. See [this milestone](https://github.com/theforeman/foreman-documentation/milestone/3) to check the progress.

For official Foreman documentation, see [Foreman Manual](https://theforeman.org/manuals/latest/index.html).

## Contributing

Contributions are welcome.
Please, familiarize yourself with [CONTRIBUTING](CONTRIBUTING.md) and [Contribution Guidelines for Foreman guides](guides/README.md#contribution-guidelines).

## Repository content

### Foreman guides

For information on working with the Foreman guides, see the [README in the `guides/` subdirectory](guides/README.md).

### Static site

The landing page for [docs.theforeman.org](https://docs.theforeman.org) is available as a generated static site.
The static content is always built from the `master` branch.
See [README in the `web/` subdirectory](web/README.md) for more information.

## Testing the site locally

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

For instructions on locally building only the guides, see [Building locally](https://github.com/theforeman/foreman-documentation/blob/master/guides/README.md#building-locally).

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

* On `master`, pull the latest changes and create a new `X.Y` branch.
* On the `X.Y` branch:
  * Update `guides/common/attributes.adoc`.
    * Set `DocState` to `unsupported`.
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
  * Add the new Foreman version to [/.github/PULL_REQUEST_TEMPLATE.md](https://github.com/theforeman/foreman-documentation/blob/master/.github/PULL_REQUEST_TEMPLATE.md).
  * Update `VERSION_LINKS` in the root `Makefile`.
  * Push the changes into `master`.
* Check the site if links and landing page appeared correctly. HTML guides should be deployed into `/X.Y`.

## License

See LICENSE files in the respective subdirectories.
