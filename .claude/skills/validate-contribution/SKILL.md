---
name: Documentation conventions
description: Validate and apply Foreman documentation conventions
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
- Use attributes instead of hardcoded product names: `{Project}`, `{ProjectServer}`, `{SmartProxy}` instead of "Foreman", "Satellite", "Capsule"
- To use attributes in code blocks, add `subs="+quotes,attributes"` option
- Attribute files: `attributes.adoc`, `attributes-base.adoc`, `attributes-foreman-el.adoc`, `attributes-foreman-deb.adoc`, `attributes-katello.adoc`, `attributes-satellite.adoc`, `attributes-orcharhino.adoc`

**Conditional content:**
- Use `ifdef::katello[]` to show content only for specific builds
- Use `ifndef::satellite[]` to hide content for specific builds
- Use comma for logic "or": `ifdef::katello,satellite[]`
- For context-specific content, combine `ifdef` and `ifeval`

**File structure:**
- Follow the [Modular documentation framework](https://redhat-documentation.github.io/modular-docs/)
- **Assemblies** (`assembly_*.adoc`): User stories at the top of `common/` - do not nest assemblies
- **Concept modules** (`con_*.adoc`): Explain what and why, start with `:_mod-docs-content-type: CONCEPT`
- **Procedure modules** (`proc_*.adoc`): Explain how, start with `:_mod-docs-content-type: PROCEDURE`
- **Reference modules** (`ref_*.adoc`): Tables and options, start with `:_mod-docs-content-type: REFERENCE`
- **Snippets** (`snip_*.adoc`): Reusable text fragments without IDs

#### Examples

**Good attribute usage:**
```asciidoc
Navigate to {ProjectWebUI} and click *Hosts*.
```

**Bad (hardcoded):**
```asciidoc
Navigate to Satellite Web UI and click *Hosts*.
```

**Good conditional:**
```asciidoc
ifdef::katello[]
This feature requires the Katello plugin.
endif::[]
```

**Good user input:**
```asciidoc
hammer organization create --name "_My_Organization_"
```

#### Instructions

When invoked (manually or automatically after making changes), perform validation and auto-fixes on modified `.adoc` files in `guides/`:

**1. File Naming Validation**
- Check: Files in `guides/common/modules/` must have correct prefixes (`con_`, `proc_`, `ref_`, `snip_`)
- Auto-fix: Rename file and update all includes if prefix doesn't match content type

**2. Content Type Attribute**
- Check: All modules (except snippets) must have content type on first line
- Auto-fix: Add missing content type based on file prefix

**3. Module ID Format**
- Check: All modules (except snippets) must have ID: `[id="title-with-dashes_{context}"]`
- Auto-fix: Add or fix ID to match title and include `_{context}` suffix

**4. Trailing Whitespace**
- Check: No trailing whitespace on any lines or at end of files
- Auto-fix: Remove all trailing whitespace

**5. Hardcoded Product Names**
- Check: Scan for "Foreman", "Satellite", "orcharhino", "Capsule" in non-conditional context
- Auto-fix: Replace with appropriate attributes (`{Project}`, `{SmartProxy}`, etc.)

**6. Vale Linting**
- Check: Run `vale` on modified files
- Report: List style violations (don't auto-fix, just report)

**7. Build Test**
- Check: Ensure modified files build successfully
- Report: Show errors if build fails

**Output format:**
```
✅ Validated contribution
Fixed:
  - Removed trailing whitespace from 3 files
  - Added content type attribute to proc_example.adoc
  
⚠ Warnings:
  - Vale: 2 style issues in proc_example.adoc
  
✓ Build: All modified files build successfully
```

**Skip validation when:**
- Changes are only to non-documentation files (Makefiles, scripts, config)
- Changes are only to `web/` directory
- Changes are to CONTRIBUTING.md
