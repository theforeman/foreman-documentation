# Writing release notes

The release notes are included in reverse chronological order. For vanilla Foreman this means the structure is:

* Headline Features
  * feature 1
  * feature 2
* Upgrade Warnings
* Deprecations
* Foreman 3.0.1
* Foreman 3.0.0
* Appendix A: Foreman Contributors

For Katello the release notes are combined. This means that Katello users will automatically read the Foreman release notes and upgrade warnings. This results in:

* Foreman 3.0 Release Notes
  * Headline Features
  * Upgrade Warnings
  * Deprecations
* Katello 4.2 Release Notes
  * Headline Features
  * Upgrade Warnings
  * Deprecations
* Foreman 3.0.1
* Katello 4.2.0
* Foreman 3.0.0
* Appendix A: Foreman Contributors
* Appendix B: Katello Contributors

Note that the release order was:

* Foreman 3.0.0
* Katello 4.2.0
* Foreman 3.0.1

If Katello 4.2.1 was released before Foreman 3.0.1 it would show up as:

* Foreman 3.0.1
* Katello 4.2.1
* Katello 4.2.0
* Foreman 3.0.0

## Generating release notes

To generate the changelogs for Foreman 3.0.0:

```sh
./redmine_release_notes katello 3.0.0 > topics/foreman-3.0.0.adoc
```

Then edit `master.adoc` and add:

```adoc
include::topics/foreman-3.0.0.adoc[leveloffset=+1]
```

For Katello it's similar. First generate them:

```sh
./redmine_release_notes katello 4.2.0 > topics/katello-4.2.0.adoc
```

Then edit `master.adoc` and add:
```adoc
ifdef::katello[]
include::topics/katello-4.2.0.adoc[leveloffset=+1]
endif::[]
```
