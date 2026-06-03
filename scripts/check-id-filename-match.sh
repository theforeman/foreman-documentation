#!/bin/bash
# Check that module IDs match their filenames
# Usage: ./scripts/check-id-filename-match.sh [file_or_directory]
#
# This script validates that AsciiDoc module IDs follow the naming convention
# where the ID matches the filename (minus the module type prefix).
#
# Exceptions handled:
# - {project-context} in ID matches "project" in filename
# - Snippets (snip_*) are skipped as they don't have IDs

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

exit_code=0
checked_count=0
warning_count=0

check_file() {
    local file="$1"
    local basename=$(basename "$file" .adoc)

    # Skip snippets - they don't have IDs
    if [[ "$basename" =~ ^snip_ ]]; then
        return 0
    fi

    ((checked_count++))

    # Remove module type prefix (con_, proc_, ref_)
    local expected="$basename"
    if [[ "$basename" =~ ^con_ ]]; then
        expected="${basename#con_}"
    elif [[ "$basename" =~ ^proc_ ]]; then
        expected="${basename#proc_}"
    elif [[ "$basename" =~ ^ref_ ]]; then
        expected="${basename#ref_}"
    fi

    # Extract ID from file (first occurrence)
    local id_line=$(grep -m1 '^\[id="' "$file" 2>/dev/null || true)

    if [[ -z "$id_line" ]]; then
        # No ID found - modules should have IDs
        echo -e "${YELLOW}Warning:${NC} $file"
        echo "  No ID found (modules should have an ID)"
        ((warning_count++))
        exit_code=1
        return 0
    fi

    # Extract the ID value
    local id_value=$(echo "$id_line" | sed -n 's/^\[id="\([^"]*\)"\]/\1/p')

    # Normalize for comparison - handle {project-context}
    local normalized_id="$id_value"
    normalized_id="${normalized_id//\{project-context\}/project}"

    # Check if ID matches expected
    if [[ "$normalized_id" != "$expected" ]]; then
        echo -e "${YELLOW}Warning:${NC} $file"
        echo "  ID '$id_value' does not match expected '$expected'"
        echo "  (based on filename without prefix)"
        echo ""
        ((warning_count++))
        exit_code=1
    fi
}

# Main logic
if [[ $# -eq 0 ]]; then
    # No arguments - check all modules
    target="guides/common/modules"
else
    target="$1"
fi

if [[ -f "$target" ]]; then
    # Single file
    check_file "$target"
elif [[ -d "$target" ]]; then
    # Directory - find all .adoc files
    while IFS= read -r -d '' file; do
        check_file "$file"
    done < <(find "$target" -name "*.adoc" -type f -print0 | sort -z)
else
    echo -e "${RED}Error:${NC} '$target' is not a file or directory"
    exit 1
fi

# Summary
echo "─────────────────────────────────────────"
echo "Checked $checked_count module(s)"

if [[ $exit_code -eq 0 ]]; then
    echo -e "${GREEN}✓ All IDs match their filenames${NC}"
else
    echo -e "${YELLOW}⚠ Found $warning_count warning(s)${NC}"
fi

exit $exit_code
