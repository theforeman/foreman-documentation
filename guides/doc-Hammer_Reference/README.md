# Creating Hammer reference

## Generating the basic reference

Use the `generate-hammer-reference.sh` script to update the generated reference.

### Prerequisite

- You have got the full help output from Hammer CLI in MarkDown format:
  ```
     hammer full-help --md >hammer.full-help.md
  ```

### Usage
```
   cd guides/
   scripts/generate-hammer-reference.sh hammer.full-help.md
```

## Manual editing

Move `content-view component` and `content-view filter` sections,
which are level 3 and have level 4 sections, to **level 2**
to decrease section nesting to 3 levels.

Initial structure:
```
2.1 content-view
2.2 content-view-environment
```

Suggested structure:
```
2.1 content-view
2.2 content-view component
2.3 content-view-environment
2.4 content-view filter
```
