#!/usr/bin/env bash
# minimal-test.sh - Minimal test to find the issue

set -x  # Enable command tracing
cd "$(dirname "${BASH_SOURCE[0]}")"

echo "=== Testing leaf.sh directly ==="
echo ""

echo "Step 1: Check if leaf.sh is executable"
ls -la leaf.sh

echo ""
echo "Step 2: Try running with bash explicitly"
bash leaf.sh --help 2>&1 | head -10

echo ""
echo "Step 3: Check dependencies"
which yq || echo "yq not found"
which jq || echo "jq not found"
which myst || echo "myst not in PATH"
ls -la .arty/bin/myst 2>/dev/null || echo ".arty/bin/myst not found"

echo ""
echo "Step 4: Try to generate docs with full error output"
bash leaf.sh ../whip.sh -o ./test-minimal 2>&1 || {
    exit_code=$?
    echo "Exit code: $exit_code"
    exit $exit_code
}
