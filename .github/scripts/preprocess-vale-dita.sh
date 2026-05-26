#!/bin/bash
# Preprocess AsciiDoc files for Vale DITA linting by injecting content type metadata
set -euo pipefail

# Create temp directory for preprocessed files
TEMP_DIR=".vale-temp"
mkdir -p "$TEMP_DIR"

# Track if we processed any files
file_count=0

# Process files passed as arguments
for file in "$@"; do
  # Skip if file doesn't exist
  if [[ ! -f "$file" ]]; then
    echo "Warning: File not found: $file" >&2
    continue
  fi

  # Create directory structure in temp
  mkdir -p "$TEMP_DIR/$(dirname "$file")"

  # Check if it's an assembly file
  if [[ $(basename "$file") == assembly_*.adoc ]]; then
    # Inject content type definition at the beginning
    {
      echo ":_mod-docs-content-type: ASSEMBLY"
      echo ""
      cat "$file"
    } > "$TEMP_DIR/$file"
    echo "Preprocessed assembly: $file" >&2
  else
    # Copy non-assembly files as-is
    cp "$file" "$TEMP_DIR/$file"
  fi

  file_count=$((file_count + 1))
done

echo "Preprocessed $file_count file(s)" >&2

# Output preprocessed file paths to stdout (one per line)
for file in "$@"; do
  if [[ -f "$file" ]]; then
    echo "$TEMP_DIR/$file"
  fi
done
