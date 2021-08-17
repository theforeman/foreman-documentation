# Static Site

Landing page for [docs.theforeman.org](https://docs.theforeman.org) is available as a [Hugo](https://gohugo.io/) project.

## Preparing the environment

Install `hugo` utility.

## Building

While the `make` commands outlined in the [guides readme](https://github.com/theforeman/foreman-documentation/blob/master/guides/README.md) output previous of the guides, for a local preview of the full site, and links, do the following:

```console
$ cd web
$ hugo server
```
Then open the URL it mentions: (http://localhost:1313/).

Use `make` or `hugo` to build contents from markdown and layouts in `public/` directory.

## Deployment

Do not commit directory public/ into git, site is generated via Github Actions.
The site is built from `master` branch.
