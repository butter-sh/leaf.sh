#!/usr/bin/env bash

cd "$(dirname "$0")"

echo "=== Finding myst.sh ==="
echo ""

# Source to get the function
source ./leaf.sh 2>/dev/null

myst_path=$(find_myst)
echo "find_myst returns: $myst_path"
echo ""

if [ -n "$myst_path" ]; then
    echo "Checking if it's executable:"
    ls -la "$myst_path"
    echo ""
    
    echo "Testing it directly:"
    echo '{"test": "value"}' > /tmp/test-data.json
    echo '<html>{{test}}</html>' > /tmp/test-template.myst
    
    "$myst_path" -j /tmp/test-data.json /tmp/test-template.myst
    echo ""
    
    echo "Checking version or help:"
    "$myst_path" --version 2>&1 || "$myst_path" --help 2>&1 | head -5
fi
