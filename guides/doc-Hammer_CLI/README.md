# Generated Hammer reference

Use the `generate-hammer-reference.sh` script to update the generated reference.

## Prerequisite

- You have got the full help output from Hammer CLI in MarkDown format:
  ```
     hammer full-help --md >hammer.full-help.md
  ```

## Usage
```
   cd guides/
   scripts/generate-hammer-reference.sh hammer.full-help.md
```
