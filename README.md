# Foreman documentation

THIS IS A WORK IN PROGRESS, VISIT OFFICIAL [FOREMAN OR KATELLO DOCUMENTATION](https://theforeman.org/documentation.html) IF YOU ARE SEEKING HELP.

This git repository contains PoC of improving Foreman documentation.

## Upstreaming Satellite Guides

This is a tree of documentation based on Red Hat Satellite 6 official books stripped off Red Hat branding. See README in the guides/ subdirectory.

* [guides](guides)

## Structure

Files that are included in more than one guide have prefixes to distingish their type of content as follows:

* `con`: File starting with `con_` contain concepts and explain the _what_ and _why_.
* `proc`: Files starting with `proc_` contain procedures and explain _how_ to achieve a specific goal.
* `ref`: Files starting with `ref_` contain references and append other files, e.g. tables with options.
* `snip`: Files starting with `snip_` contain snippets that are reused throughout multiple guides, e.g. admonitions.

## Conventions

* User input is surrounded by underscores (`_`) to indicate variable input, e.g. `hammer organization create --name "_My Organization_" --label "_my_organization_"`.

## License

See LICENSE files in individual subdirectories
