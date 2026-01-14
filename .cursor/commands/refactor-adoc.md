# Refactor adoc file

## Overview

Refactor the following `.adoc` file according to the following title.

## Instructions

Follow these principles:

- Rename the file as `prefix_new-title.adoc`.
- Change the ID of the file as `[id="new-title"]` if the file contains an ID.
- Update all includes of that file in all other `.adoc` files.
- Update all occurrences of the ID in all other `.adoc` files. If the old ID contains `_{context}`, the tail of the occurrence after `_` is a variable string.
