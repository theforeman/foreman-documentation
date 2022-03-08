# Foreman documentation

THIS IS A WORK IN PROGRESS. VISIT THE OFFICIAL [FOREMAN OR KATELLO DOCUMENTATION](https://theforeman.org/documentation.html) IF YOU ARE SEEKING HELP.

This git repository contains PoC of improving Foreman documentation.

BLA

## Foreman Guides

This is a tree of documentation based on Red Hat Satellite 6 official books.
Contributions are welcome.
See README in the guides/ subdirectory for more information.

* [guides](guides/README.md)

## Static Site

The landing page for [docs.theforeman.org](https://docs.theforeman.org) is available as a generated static site.
See README in the web/ subdirectory for more information.

* [web](web/README.md)

## Deployment

Github actions perform HTML (with link validation), PDF and WEB artifact creation and if succeeded and branch is master or stable, artifacts are downloaded, extracted and deployed (commited into gh-pages). Deployment does not delete files, in order to remove some unwanted content, manual deletion and push into gh-pages must be performed.

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
  * Create a copy of [/web/content/release-nightly.md](https://github.com/theforeman/foreman-documentation/tree/master/web/content/release-nightly.md) as `release-X.Y.md` and edit it accordingly.
  * Add the new release versions to the site's index page and navigation bar by editing [/web/content/index.adoc](https://github.com/theforeman/foreman-documentation/blob/master/web/content/index.adoc) and [/web/content/js/nav.js](https://github.com/theforeman/foreman-documentation/blob/master/web/content/js/nav.js).
  * Test the changes by following the instructions in [/web/README.md](https://github.com/theforeman/foreman-documentation/tree/master/web/README.md) to deploy the website locally.
  * Add the new Foreman version to [/.github/PULL_REQUEST_TEMPLATE.md](https://github.com/theforeman/foreman-documentation/blob/master/.github/PULL_REQUEST_TEMPLATE.md).
  * Push the changes into `master`.
* Check the site if links and landing page appeared correctly. HTML guides should be deployed into `/X.Y`

## License

See LICENSE files in individual subdirectories.
