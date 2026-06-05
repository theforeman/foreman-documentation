---
name: Rename a module
description: Refactor adoc file by a given title
disable-model-invocation: true
---
### Refactor adoc file by a given title

#### Overview

This command changes the title, ID, and filename of an assembly, module, or snippet according to a new title, and updates all includes and ID references across the documentation.

**Usage:**
```
/refactor-adoc @old-file.adoc "New title"
```

**What it does:**
- Renames the file with the appropriate prefix (e.g., `proc_new-title.adoc`)
- Updates the ID if present (e.g., `[id="new-title_{context}"]`)
- Updates the title if present (e.g., `= New title`)
- Updates all `include::` directives that reference this file
- Updates all cross-references to the old ID throughout the documentation

**When to use:**
- When you need to rename a documentation file to better match its content
- After significantly revising the content of a module
- When improving heading clarity requires filename changes

#### Instructions

Refactor the following `.adoc` file according to the following title.
Follow these principles:

- Rename the file as `prefix_new-title.adoc`.
- Change the ID of the file as `[id="new-title"]` if the file contains an ID.
- Change the title of the file as `= New title` if the file contains a title.
- Update all includes of that file in all other `.adoc` files.
- If the original file contains an ID, update all occurrences of the ID in all other `.adoc` files. If the old ID contains `_{context}`, the tail of the occurrence after `_` is a variable string.
