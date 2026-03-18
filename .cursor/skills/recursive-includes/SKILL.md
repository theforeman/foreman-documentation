---
name: recursive-includes
description: Process command recursively for all included files
disable-model-invocation: true
---
# Process command recursively for all included files

## Overview

This command extends other Cursor commands (like `/prerequisites`, `/abstract`, etc.) to apply them recursively to all included .adoc files. While most commands are designed to process a single file, this command allows you to point at a master.adoc or assembly_*.adoc file and process all the includes within it, and all the includes within those includes, etc.

## Usage

```
/recursive-includes @master.adoc /prerequisites
/recursive-includes @assembly_example.adoc /abstract
```

## Instructions

Process the specified command recursively for all included .adoc files using a **two-phase approach** to ensure no files are missed:

### Phase 1: Extract complete list of included files

1. Start with the specified .adoc file (master.adoc, assembly_*.adoc, or any .adoc file).
2. Create a complete list of all .adoc files that are included, recursively:
   - Parse all `include::` directives in the starting file.
   - For each included .adoc file, recursively parse its `include::` directives.
   - Continue recursively until all nested includes are discovered.
   - Handle both relative paths (e.g., `common/modules/proc_example.adoc`) and paths with `../` navigation.
   - Resolve all paths relative to the file containing the include directive.
   - Track all unique .adoc files in a list, avoiding duplicates.
3. Output the complete list of files to be processed so the user can review it.
4. The list should include:
   - The total count of files found
   - The full path of each file

### Phase 2: Apply command to each file

1. For each file in the extracted list from Phase 1, apply the specified command (e.g., `/prerequisites`, `/abstract`).
2. Process files in a logical order:
   - Start with the deepest nested files first (leaf modules).
   - Then process their parents (assemblies).
   - Finally process the top-level file.
   - This ordering ensures that changes to included files are visible when processing parent files.
3. For each file:
   - Clearly indicate which file is being processed (e.g., "Processing file 3/15: proc_example.adoc").
   - Apply the command according to its specific instructions.
   - Report any issues or changes made.
4. Provide a summary at the end showing:
   - Total files processed
   - Number of files modified
   - Number of issues found requiring human review
   - List of files that were skipped (if any) with reasons

### Important notes

- **Do not guess or skip files**: The two-phase approach ensures all included files are explicitly identified before processing begins.
- **Handle errors gracefully**: If a file cannot be read or processed, note it and continue with other files.
- **Avoid processing the same file twice**: Track which files have been processed to avoid duplicate work.
- **Respect command-specific rules**: Each command (prerequisites, abstract, etc.) has its own rules about which file types it applies to. Respect those rules when processing the list.

### Example include parsing

Given a file with these includes:
```asciidoc
include::common/modules/con_example.adoc[]
include::common/assembly_example.adoc[leveloffset=+1]
```

The parser should:
1. Resolve `common/modules/con_example.adoc` relative to the current file's directory.
2. Resolve `common/assembly_example.adoc` relative to the current file's directory.
3. Read each of those files and recursively parse their includes.
4. Add all unique .adoc files to the processing list.

### Error handling

- If an included file doesn't exist, note it but continue processing other files.
- If an include path cannot be resolved, report it for human review.
- If a command fails for a specific file, note it and continue with remaining files.
- Provide a clear summary of any errors encountered.
