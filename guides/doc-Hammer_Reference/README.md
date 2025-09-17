# Creating Hammer reference

## Generating the reference

Use the `generate-hammer-reference.sh` script to generate the reference.

### Prerequisites

- Ensure all Foreman plugins are enabled on your Foreman instance.
- You have got the full help output from Hammer CLI in MarkDown format:
  ```
     hammer full-help --md >hammer.full-help.md
  ```

### Usage
```
   cd guides/
   mkdir common/hammer-reference
   scripts/generate-hammer-reference.sh hammer.full-help.md
```

## Manual editing

Move `content-view component` and `content-view filter` sections, which are level 3 and have level 4 sections, to **level 2** to decrease section nesting to 3 levels.

Generated structure:
```
2.1 content-view
   2.1.x content-view component
   2.1.y content-view filter
2.2 content-view-environment
```

Manually updated structure:
```
2.1 content-view
2.2 content-view component
2.3 content-view-environment
2.4 content-view filter
```
