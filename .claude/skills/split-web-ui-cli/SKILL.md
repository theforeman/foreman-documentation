---
name: Split a module into web UI and CLI modules
description: Split a module into web UI and CLI modules
disable-model-invocation: true
---
#### Overview

When a procedure module contains both web UI steps (`.Procedure`) and CLI steps (`.CLI procedure`) in the same file, it should be split into two separate files for better modularity and clarity.

**Usage:**
```
/split-web-ui-cli @proc_example.adoc
```

**What it creates:**
- `proc_original-name-by-using-web-ui.adoc` - Contains the web UI procedure
- `proc_original-name-by-using-cli.adoc` - Contains the CLI procedure

**File structure:**
- Both files include the introduction text from the original file
- Both files have adjusted IDs: `[id="original-id-by-using-web-ui"]` and `[id="original-id-by-using-cli"]`
- Both files have adjusted headings: `= Original heading by using {ProjectWebUI}` and `= Original heading by using Hammer CLI`
- Both files have adjusted abstracts if needed

**When to use:**
- When a single procedure file contains both `.Procedure` and `.CLI procedure` sections
- When you want to make procedures more modular and easier to maintain
- When users need to choose between different interfaces for the same task

#### Instructions

Follow these principles:

* Include the introduction (before `.Procedure`) in both new files.
* Adjust the ID of the new files: `[id="original-id-by-using-web-ui"]` and `[id="original-id-by-using-cli"]`. Use lower case and separate words with hyphens `-`. Drop `_{context}` from the IDs.
* Adjust the heading of the new files: `= Original heading by using {ProjectWebUI}` and `= Original heading by using Hammer CLI`.
* Adjust the abstract if needed: `Original abstract from the {ProjectWebUI}` or `Original abstract by using the {ProjectWebUI}` and `Original abstract by using Hammer CLI`.
* Include both new files in its parent file to replace the original `proc_*.adoc` file.
* When creating the CLI file, replace `.CLI procedure` with `.Procedure` and do not include a separate CLI ID.
* Search and replace the ID string of the original file with the ID string of the new file `[id="original-id-by-using-web-ui"]` in all `*.adoc` files. Remove `_<context-as-variable-string>` during the replacement.
* Delete the original file.
