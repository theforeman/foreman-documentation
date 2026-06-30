#!/bin/bash
# Check that module IDs, headings, and filenames match
# Usage: ./scripts/check-filename-id-heading-match.sh [file_or_directory]
#
# This script validates that AsciiDoc modules follow the naming convention:
# - ID must match the filename (minus the module type prefix: con_, proc_, ref_)
# - Heading must match the ID (when both are normalized by accounting for attribute substitutions)

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

    # Extract heading (first level-one heading after the ID)
    local heading_line=$(grep -m1 '^= ' "$file" 2>/dev/null || true)
    local heading_value=""
    if [[ -n "$heading_line" ]]; then
        # Remove the = prefix and leading/trailing whitespace
        heading_value=$(echo "$heading_line" | sed 's/^= *//' | sed 's/ *$//')
    fi

    # Normalize for comparison - handle attribute substitutions
    local normalized_id="$id_value"

    # Replace attributes with their filename equivalents
    normalized_id="${normalized_id//\{project-context\}/project}"
    normalized_id="${normalized_id//\{smart-proxy-context\}/smartproxy}"
    normalized_id="${normalized_id//\{smart-proxies-context\}/smartproxies}"
    normalized_id="${normalized_id//\{smart-proxy-context-titlecase\}/smartproxy}"
    normalized_id="${normalized_id//\{ProjectNameID\}/project}"
    normalized_id="${normalized_id//\{ProjectServerID\}/project-server}"
    normalized_id="${normalized_id//\{customreposid\}/repositories}"
    normalized_id="${normalized_id//\{customrepoid\}/repository}"
    normalized_id="${normalized_id//\{customproductid\}/product}"
    normalized_id="${normalized_id//\{FreeIPA-context\}/freeipa}"
    normalized_id="${normalized_id//\{freeipa-context\}/freeipa}"
    normalized_id="${normalized_id//\{insights-id\}/insights}"
    normalized_id="${normalized_id//\{insights-iop-id\}/insights}"
    normalized_id="${normalized_id//\{foreman-installer\}/foreman-installer}"
    normalized_id="${normalized_id//\{awx-context\}/awx}"
    normalized_id="${normalized_id//\{compute-resource-id\}/compute-resource}"
    normalized_id="${normalized_id//\{OpenStack-id\}/openstack}"
    normalized_id="${normalized_id//\{KubeVirt-id\}/kubevirt}"

    # Normalize heading for comparison
    local normalized_heading=""
    if [[ -n "$heading_value" ]]; then
        # Convert heading to lowercase and replace spaces/underscores with hyphens
        normalized_heading=$(echo "$heading_value" | tr '[:upper:]' '[:lower:]' | sed 's/[_ ]/-/g')

        # Apply attribute substitutions for heading-specific attributes
        # These are the capitalized attribute names used in headings
        normalized_heading="${normalized_heading//\{projectname\}/project}"
        normalized_heading="${normalized_heading//\{project\}/project}"
        normalized_heading="${normalized_heading//\{projectserver\}/project-server}"
        normalized_heading="${normalized_heading//\{smartproxy\}/smartproxy}"
        normalized_heading="${normalized_heading//\{smartproxyserver\}/smartproxy-server}"
        normalized_heading="${normalized_heading//\{smartproxyservers\}/smartproxy-servers}"
        normalized_heading="${normalized_heading//\{freeipa\}/freeipa}"
        normalized_heading="${normalized_heading//\{insights\}/insights}"
        normalized_heading="${normalized_heading//\{insights-iop\}/insights}"
        normalized_heading="${normalized_heading//\{nbsp\}/}"  # Remove non-breaking spaces
        normalized_heading="${normalized_heading//\{customssl\}/custom-ssl}"
        normalized_heading="${normalized_heading//\{customfiletype\}/custom-file-type}"
        normalized_heading="${normalized_heading//\{openstack\}/openstack}"
        normalized_heading="${normalized_heading//\{keycloak\}/keycloak}"
        normalized_heading="${normalized_heading//\{rhel\}/rhel}"
        normalized_heading="${normalized_heading//\{the-cockpit\}/cockpit}"
        normalized_heading="${normalized_heading//\{rhcloud\}/rhcloud}"
        normalized_heading="${normalized_heading//\{loraxcompose\}/lorax-compose}"
        normalized_heading="${normalized_heading//\{foreman-installer\}/foreman-installer}"
        normalized_heading="${normalized_heading//\{compute-resource\}/compute-resource}"
        normalized_heading="${normalized_heading//\{openstack\}/openstack}"
        normalized_heading="${normalized_heading//\{kubevirt\}/kubevirt}"

        # Normalize Hammer CLI and Web UI text in headings
        # The convention is: ID and filename contain "by-using-cli"/"by-using-web-ui", heading contains "by using Hammer CLI"/"by using {ProjectWebUI}"
        normalized_heading="${normalized_heading//hammer-cli/cli}"
        normalized_heading="${normalized_heading//\{projectwebui\}/web-ui}"
    fi

    # Check if ID matches filename
    local id_mismatch=false
    if [[ "$normalized_id" != "$expected" ]]; then
        id_mismatch=true
    fi

    # Check if heading matches ID (if heading exists)
    local heading_mismatch=false
    if [[ -n "$normalized_heading" && "$normalized_heading" != "$normalized_id" ]]; then
        heading_mismatch=true
    fi

    # Report any mismatches
    if [[ "$id_mismatch" = true || "$heading_mismatch" = true ]]; then
        echo -e "${YELLOW}Warning:${NC} $file"

        if [[ "$id_mismatch" = true ]]; then
            echo "  ID '$id_value' does not match expected '$expected'"
            echo "  (based on filename without prefix)"
        fi

        if [[ "$heading_mismatch" = true ]]; then
            echo "  Heading '$heading_value' does not match ID"
            echo "  (normalized heading: '$normalized_heading', normalized ID: '$normalized_id')"
        fi

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
