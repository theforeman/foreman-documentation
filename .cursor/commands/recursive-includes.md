# Process AsciiDoc includes recursively

## Overview

Recursively process all files included via `include::` directives in an AsciiDoc file.
This command applies a specified command to each included file.

## Usage

Use this command in combination with another command. For example:
* Apply `heading.md` to all included files.
* Apply any other command recursively through the include tree.
For example, to call this command together with the command to review headings, type the following into the Cursor agent chat: `/heading and /recursive-includes`.

## Recursive processing logic

If the current file contains `include::` directives (e.g., `master.adoc` or `assembly_*.adoc`):

1. Extract all included file paths from `include::` directives.
2. Resolve each path:
   - If path starts with `common/`, resolve from `guides/common/`.
   - If path starts with `modules/`, resolve from `guides/common/modules/`.
   - Otherwise, resolve relative to the current file's directory.
3. For each included `.adoc` file, apply the specified command recursively.
4. Skip non-`.adoc` files.

## Notes

* This command is designed to work with the modular documentation structure.
* This command follows the same path resolution rules used by AsciiDoc includes.
* This command only processes `.adoc` files, skipping other file types.
