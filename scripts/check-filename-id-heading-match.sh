#!/bin/bash
# Compatibility wrapper for the Python implementation.
exec "$(dirname "$0")/check-filename-id-heading-match.py" "$@"
