---
name: doc-structure-checker
description: Validates and fixes AsciiDoc structural issues including assembly format, module templates, prerequisites, and nesting depth.
---

# Document structure checker

I validate and fix structural issues in modular AsciiDoc documentation.

## References

Before starting, read these files in `references/`:
- `modular_documentation_templates_checklist.md` - **Primary reference** for validation rules
- `TEMPLATE_ASSEMBLY.adoc` - Canonical assembly structure
- `TEMPLATE_CONCEPT.adoc` - Canonical concept module structure
- `TEMPLATE_PROCEDURE.adoc` - Canonical procedure module structure
- `TEMPLATE_REFERENCE.adoc` - Canonical reference module structure

## 1. File preparation

The user provides a path to `master.adoc`.

**If `adoc-file-list.txt` exists:** Use it. Skip to Section 3.

**If missing:** Create the manifest:
1. Open `master.adoc` and identify all `include::` files recursively
2. Create `adoc-file-list.txt` with discovered file paths, one per line

## 2. Files to exclude

Skip: `_attributes*.adoc`, `_title-attributes.adoc`, `snip_*.adoc`, files in `common/` directory.

## 3. Execution workflow

1. **Read** the reference files in `references/` to understand the rules
2. **Read** `adoc-file-list.txt` to get the file manifest
3. **Categorize** each file as assembly or module by checking for `:_mod-docs-content-type:`
4. **Validate** each file against the checklist rules
5. **Fix** issues with clear solutions (see below)
6. **Flag** issues needing human decision (see below)
7. **Summarize** changes made and issues flagged

## 4. What to fix vs flag

**Fix automatically:**
- Prerequisites using ordered lists → convert to unordered
- Multi-step procedures using bullets → convert to ordered list
- Single-step procedures using numbered list → convert to bullet
- Missing blank lines between include statements
- Supplementary content under steps missing `+` connector

**Flag for human review:**
- Missing `[role="_abstract"]` → instruct user to run `short-description-expert`
- Missing `:_mod-docs-content-type:` declaration
- Nesting depth exceeding 3 levels
- Concept/reference modules containing imperative statements
- Procedure modules with multiple `.Procedure` blocks
- Block titles not in the allowed list

## 6. Output format

```
=== Structure Check Summary ===

Files checked: X
Issues fixed: Y
Issues flagged for review: Z

FIXED:
- path/to/file.adoc: [description of fix]

FLAGGED (needs human review):
- path/to/file.adoc: [issue description]

NO ISSUES:
- path/to/file.adoc
```
