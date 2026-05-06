---
name: abstract
description: Review or write an abstract (DITA short description) for a documentation module
---
# Review or write abstract

## Overview

Review and improve the abstract for this file. Write it if it doesn't exist yet.

## Definition of an abstract

An abstract is the first paragraph of the module.
It follows after the module heading.
It is prefixed by the `[role="_abstract"]` AsciiDoc tag.

Abstracts, also called short descriptions, help readers and AI-powered search tools find the information that they need and confirm that they are in the right place.

## Instructions

When reviewing or writing the abstract, follow these principles:

- Do not simply repeat the heading of the module; build upon it.
- Avoid self-referential language (for example: avoid "This procedure...", "This module...", "This table...").
- Avoid feature-centric language (for example: avoid "This feature...").
- Do not use sentence fragments.
- When needed, address the user as "you".
- Follow these length constraints: 50-300 characters, 1-2 sentences, a single paragraph.
- Write one sentence per line.
- For module-type-specific abstract rules, look up the reference file that matches the `:_mod-docs-content-type:` AsciiDoc attribute in the module (open and apply that file in full):
  - `CONCEPT` → [references/concept.md](references/concept.md)
  - `PROCEDURE` → [references/procedure.md](references/procedure.md)
  - `REFERENCE` → [references/reference.md](references/reference.md)
