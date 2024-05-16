# Contributing to Foreman Documentation

Foreman community welcomes all feedback, issues, pull requests (PRs), and reviews.
Every contributor has different backgrounds, interests, and experiences with Foreman and its open source community.

We give ourselves these guidelines to collaborate and contribute to Foreman documentation more efficiently.
It helps everyone to set expectations, communicate conventions, and ensures happy collaborative work across organisations and backgrounds.
We respect each others time and energy spent on Foreman documentation.

## Maintainers

* help less experienced community members with git, Github, PRs, asciidoc, and asciidoctor.
* expect a basic effort in contributions.
* only merge PRs if the Github Actions are green.
* read the proposed change and make friendly and helpful comments.
* ping community members with more experience if they are unsure about specific details.
* try to review PRs in a timely manner.
* keep non-trivial PRs open for at least 24 hours to allow for input from the community.

## Contributors

* are able to make meaningful contributions to the Foreman documentation, regardless of their experience with git, asciidoc, writing documentation, or Foreman.
* familiarize themselves with the [Pull Request Checklist](#Pull-Request-Checklist).
* open additional issues if a contribution is incomplete.
* are invited to review other PRs.

## Pull Request Checklist

* [ ] I am familiar with the conventions as specified in the [guides/README.md](guides/README.md) file.
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

## Crafting Great Pull Requests

Please explain why someone else should merge your proposed change:

* What has been changed?
* Why has it been changed?
* Are there any alternatives to my PR?
* Are there any regressions or downsides to my PR?
* Does my PR make multiple changes and therefore require multiple commits?
Ideally, each individual change correlates to an individual commit.

## Capitalization

All headings are sentence case.
We capitalize the following terms:

* Ansible
* Candlepin
* Chef
* Deb (content type)
* Discovery (service)
* Enterprise Linux (umbrella term for RHEL-derivatives)
* Hammer
* Insights (Red Hat product)
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
* Subscription Manager (Red Hat product)
* Tracer (utility)
* Yum (content type)

We do not capitalize the following terms:

* content view
* lifecycle environment
* manifest
* Red Hat subscription manifest
* subscription

## Further Information

* [Contributing Guidelines for Github documentation](https://github.com/github/docs/blob/main/CONTRIBUTING.md)
* [theforeman.org/contribute](https://theforeman.org/contribute.html)
* [7 Git tips for technical writers](https://opensource.com/article/22/11/git-tips-technical-writers)
