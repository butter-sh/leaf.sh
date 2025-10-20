#!/usr/bin/env bash

cd "$(dirname "$0")"

echo "=== Tracing actual generation with debug output ==="
echo ""

# Run with DEBUG to see what's happening
rm -rf /tmp/working-test
DEBUG=1 bash leaf.sh ../whip.sh -o /tmp/working-test 2>&1 | grep -A5 "README"

echo ""
echo "=== Checking the result ==="
echo ""

if [ -f /tmp/working-test/debug-data.json ]; then
    echo "Checking JSON file (first 1000 chars of readme_content):"
    jq -r '.readme_content' /tmp/working-test/debug-data.json 2>/dev/null | head -c 1000 || echo "Error reading JSON"
    
    echo ""
    echo ""
    echo "=== Searching for escaped backticks in JSON ==="
    # Use grep in binary mode to avoid shell escaping issues
    if grep -aoP '\\`' /tmp/working-test/debug-data.json | head -3; then
        count=$(grep -aoP '\\`' /tmp/working-test/debug-data.json | wc -l)
        echo "Found $count escaped backticks in JSON file"
    else
        echo "No escaped backticks found in JSON"
    fi
fi
