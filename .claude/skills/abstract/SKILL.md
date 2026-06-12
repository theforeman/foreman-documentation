---
name: Abstracts
description: Review or write an abstract (also called a short description) for a documentation module
---
#### Overview

An abstract is the first paragraph of a documentation module that helps readers and AI-powered search tools find the information they need and confirm they are in the right place.

An abstract follows after the module heading and is prefixed by the `[role="_abstract"]` AsciiDoc tag.

Abstracts typically contain:
- The "What" - what the content covers
- The "Why" - why it matters or when to use it
- Where appropriate, an example use case

**Guidelines:**
- Do not simply repeat the heading of the module; build upon it
- Avoid self-referential language (e.g., "This procedure...", "This module...", "This table...")
- Avoid feature-centric language (e.g., "This feature...")
- Do not use sentence fragments
- When addressing the user, address them as "you"
- Follow these length constraints: 50-300 characters, 1-2 sentences, a single paragraph

**Module-type-specific guidelines:**
- `CONCEPT` modules: See [references/concept.md](references/concept.md)
- `PROCEDURE` modules: See [references/procedure.md](references/procedure.md)
- `REFERENCE` modules: See [references/reference.md](references/reference.md)

#### Instructions

Review and improve the abstract for this file. Write it if it doesn't exist yet.

When reviewing or writing the abstract, follow the guidelines in the Overview section.

For module-type-specific abstract rules, look up the reference file that matches the `:_mod-docs-content-type:` AsciiDoc attribute in the module (open and apply that file in full).
