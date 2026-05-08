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
