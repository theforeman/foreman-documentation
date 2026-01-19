# Refactor adoc file by a given title

## Overview

Change the title (if present), ID (if present), and file name of an assembly, module, or snippet according to a new title.
Update the includes and any ID references across all documentation.

Usage:

```
/refactor-adoc @old-file.adoc "New title"
```

## Instructions

Refactor the following `.adoc` file according to the following title.
Follow these principles:

- Rename the file as `prefix_new-title.adoc`.
- Change the ID of the file as `[id="new-title"]` if the file contains an ID.
- Change the title of the file as `= New title` if the file contains a title.
- Update all includes of that file in all other `.adoc` files.
- If the original file contains an ID, update all occurrences of the ID in all other `.adoc` files. If the old ID contains `_{context}`, the tail of the occurrence after `_` is a variable string.
