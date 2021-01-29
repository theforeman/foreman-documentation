# Foreman documentation

THIS IS A WORK IN PROGRESS, VISIT OFFICIAL [FOREMAN OR KATELLO DOCUMENTATION](https://theforeman.org/documentation.html) IF YOU ARE SEEKING HELP.

This git repository contains PoC of improving Foreman documentation.

## Foreman Guides

This is a tree of documentation based on Red Hat Satellite 6 official books.
See README in the guides/ subdirectory for more information.

* [guides](guides/README.md)

## Static Site

Landing page for [docs.theforeman.org](https://docs.theforeman.org) is available as a Hugo project.
See README in the web/ subdirectory for more information.

* [web](web/README.md)

## Deployment

Github actions perform HTML (with link validation), PDF and WEB artifact creation and if suceeded and branch is master or stable, artifacts are downloaded, extracted and deployed (commited into gh-pages). Deployment does not delete files, in order to remove some unwanted content, manual deletion and push into gh-pages must be performed.

## License

See LICENSE files in individual subdirectories
