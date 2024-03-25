# Foreman documentation

This git repository contains the following documentation:

* Official documentation for the Katello project
* PoC of improving documentation for the Foreman project. See [this milestone](https://github.com/theforeman/foreman-documentation/milestone/3) to check the progress.

For official Foreman documentation, see [Foreman Manual](https://theforeman.org/manuals/latest/index.html).

## Contributing

Contributions are welcome.
Please, familiarize yourself with [CONTRIBUTING](CONTRIBUTING.md) and [Contribution Guidelines for Foreman guides](guides/README.md#contribution-guidelines).

## Repository content

### Foreman guides

This is a tree of documentation based on Red Hat Satellite 6 official books.
See [README in the `guides/` subdirectory](guides/README.md) for more information.

### Static site

The landing page for [docs.theforeman.org](https://docs.theforeman.org) is available as a generated static site.
The static content is always built from the `master` branch.
See [README in the `web/` subdirectory](web/README.md) for more information.

## Testing locally

To build both static site and guides for easy local testing, there is the global `Makefile` in the root directory with the following targets:

* `html`: builds HTML guides with all contexts (`foreman-el`, `foreman-deb`, `katello`, `satellite`, and `orcharhino`)
* `web`: builds static site using the `nanoc` tool
* `compile`: compiles all content into a single directory `./result`
* `serve`: serves the result directory via a python web server (the default target)

To test the whole site locally, perform `make serve` command and open up `http://localhost:5000`.
Use `PORT=5008` to change the web server port (5000 by default).
It builds all contexts so the initial build can be slow, make sure to use `-j` option for faster builds on modern multi-core machines.
Stable versions are symlink to the nightly (current) version, this can cause issues for deleted (or renamed) guides.

## Deployment

Github actions perform HTML (with link validation) and WEB artifact creation and if succeeded and branch is master or stable, artifacts are downloaded, extracted and deployed (commited into gh-pages). Deployment does not delete files, in order to remove some unwanted content, manual deletion and push into gh-pages must be performed.

When a commit is pushed into `master`:

* All artifacts are built.
* Static WEB and HTML is downloaded and copied into `/` or `/nightly` respectively.
* Changes are pushed into `gh-pages` branch.

When a commit is pushed into `X.Y`:

* All artifacts are built.
* HTML artifact is downloaded and copied into `/X.Y`.
* Changes are pushed into `gh-pages` branch.

## Branching new release

* Create a new `X.Y` branch.
  * Update `guides/common/attributes.adoc`
    * Set `DocState` to `unsupported`
    * Set `ProjectVersion` to `X.Y` and set the matching `KatelloVersion`
  * Push into `X.Y` branch.
* Update master
  * Update `ProjectVersionPrevious` to `X.Y` in `guides/common/attributes.adoc`
  * Create a copy of [/web/releases/nightly.json](https://github.com/theforeman/foreman-documentation/tree/master/web/releases/nightly.json) as `X.Y.json` and edit it accordingly. Remove guides which aren't ready for stable branches.
  * Create a copy of [/web/releases/nightly.adoc](https://github.com/theforeman/foreman-documentation/tree/master/web/releases/nightly.adoc) as `X.Y.adoc` and edit it accordingly. Remove guides which aren't ready for stable branches.
  * Test the changes by following the instructions in [/web/README.md](https://github.com/theforeman/foreman-documentation/tree/master/web/README.md) to deploy the website locally.
  * Add the new Foreman version to [/.github/PULL_REQUEST_TEMPLATE.md](https://github.com/theforeman/foreman-documentation/blob/master/.github/PULL_REQUEST_TEMPLATE.md).
  * Update `VERSION_LINKS` in the root `Makefile`.
  * Push the changes into `master`.
* Check the site if links and landing page appeared correctly. HTML guides should be deployed into `/X.Y`

## License

See LICENSE files in individual subdirectories.
