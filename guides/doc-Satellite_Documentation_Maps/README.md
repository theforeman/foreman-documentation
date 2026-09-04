# Documentation Maps

This directory contains Asciidoc documentation maps, which organize Foreman/Satellite documentation into job-based categories.

## Job-based documentation

Satellite documentation is based on the Jobs To Be Done (JTBD) framework.
A _job_ is a task that a user "hires" a product for.

Satellite documentation is organized into _categories_.
Each _category_ contains _top-level jobs_.
_Top-level jobs_ can, but do not have to, contain _sub-jobs_.

## How to add new jobs

To add a new top-level job, create a file in the `doc-Satellite_Documentation_Maps/maps/` directory.
Use the existing map files as a template.
Specifically, note that a map file must have the `:_mod-docs-content-type: MAP` attribute set and does not contain a heading.

To add a sub-job under a top-level job, include the required `con_*.adoc`, `proc_*.adoc`, and `ref_*.adoc` files in a top-level job MAP file.

## Guide structure

* `master.adoc`: This is the top-level guide file.
A symlink `navigation.adoc` points to `master.adoc`.
The `navigation.adoc` symlink is required downstream.
* `whats-new.adoc`, `discover.adoc`, `get-started.adoc`, etc., included in `master.adoc`: These files represent Satellite documentation categories.
The list of categories is determined centrally downstream; do not create your own categories or rename the existing ones.
* `maps/<job-name>.adoc` files included in category files: These files represent top-level jobs.
NOTE: Maps are similar to assemblies in their purpose, however while assemblies never contain another assembly as an include (per repository conventions), maps can contain assemblies.
* `assembly_*.adoc`, `con_*.adoc`, `proc_*.adoc`, and `ref_*.adoc` files included in `maps/<job-name>.adoc`: These files supply the content to document the job.

```
master.adoc (top-level guide)
├── whats-new.adoc (category)
│   └── maps/<job-name>.adoc (top-level job)
│       ├── con_*.adoc (content)
│       ├── proc_*.adoc (content)
│       └── ref_*.adoc (content)
├── discover.adoc (category)
│   └── maps/<job-name>.adoc (top-level job)
│       └── ...
├── get-started.adoc (category)
│   └── maps/<job-name>.adoc (top-level job)
│       └── ...
└── ... (other category files)
```

NOTE: Some assembly files might contain the `:chunk-to-content:` attribute.
If an assembly file contains `:chunk-to-content:`, it must also include a heading (`=`) and a short introduction (`[role="_abstract"]`) directly rather than as an include.
Additionally, all its included modules must use `toc="no"` in the include directive.
For more details on chunking, see downstream documentation.
+
Chunking is generally discouraged.
It is preferable to structure documentation for a job so that chunking is not needed.
Documentation that is properly arranged for performance, usability, and search does not need to implement chunking.

## Building the Guide

The guide is built as part of the Foreman documentation build system.
Only the `satellite` build target is enabled for this guide.
You cannot build the guide for the other build targets.
