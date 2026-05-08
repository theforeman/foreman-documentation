---
name: Validate against repository conventions
description: Check if the contribution conforms to Foreman documentation conventions
disable-model-invocation: false
---
#### Overview

Foreman documentation follows specific conventions for code, images, attributes, conditionals, and file structure. These conventions ensure consistency across all guides and enable multi-product builds from a single source.

**Code conventions:**
- Use UTF-8 character encoding in source files
- Do not add trailing whitespace on lines or in files
- Surround user input with underscores to indicate variable input (e.g., `hammer organization create --name "_My_Organization_"`)

**Images:**
- Save guide-specific images to `guides/doc-<GuideName>/images/`
- Save shared images to `guides/common/images/`
- Create editable diagrams using [diagrams.net](https://www.diagrams.net/) in `drawio` format, place in `guides/image-sources/`, export to SVG

**AsciiDoc attributes:**
- Use attributes instead of hardcoded product names: `{Project}` instead of `Foreman`, `{ProjectServer}` instead of `Satellite Server`, `{SmartProxy}` instead of `Capsule`, etc.
- To use attributes in code blocks, add the `subs="+quotes,attributes"` option
- Attributes are located in the files named `attributes*.adoc` in `guides/common`.

**Conditional content:**
- Use `ifdef::[]` to show content only for specific builds.
For example, `ifdef::katello[]` to show content only for the katello build target.
- Use `ifndef::[]` to hide content for specific builds
For example, `ifndef::satellite[] to hide content for the satellite build target.
- Use comma for logic "or": `ifdef::katello,satellite[]`
- Nest conditionals for logic "and".

**File structure:**
- Follow the [Modular documentation framework](https://redhat-documentation.github.io/modular-docs/)
- **Assemblies** (`assembly_*.adoc`): User stories at the top of `common/`.
Do not nest assemblies: An assembly never contains another assembly as an include.
If you need to include an assembly in another assembly, include its modules directly and adjust the `[leveloffset]` value to show the nesting.
- **Concept modules** (`con_*.adoc`): Explain what and why.
Start with `:_mod-docs-content-type: CONCEPT`
- **Procedure modules** (`proc_*.adoc`): Explain how
.Start with `:_mod-docs-content-type: PROCEDURE`
- **Reference modules** (`ref_*.adoc`): Tables, options, lists, and other referential material.
Start with `:_mod-docs-content-type: REFERENCE`
- **Snippets** (`snip_*.adoc`): Reusable text fragments without IDs
- When unsure what a particular file type should look like, copy an existing file of the same type and use it as a template.

#### Instructions

When invoked (manually or automatically after making changes), validate modified `.adoc` files in `guides/` against the conventions described above.

**Auto-fix the following:**
- UTF-8 character encoding
- Trailing whitespace on lines and at end of files
- Variable input formatting
- Missing `subs="+quotes,attributes"` in code blocks that use attributes
- File naming and prefixes (`con_`, `proc_`, `ref_`, `snip_`)
- Content type attributes (must be on first line)
- Vale linting issues

**Report only if issues were discovered (do not auto-fix):**
- Image locations (guide-specific vs. shared directories)
- Assembly structure issues (nested assemblies)
- Conditional content usage

**Report final validation step:**
- Build test results
