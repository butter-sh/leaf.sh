#!/usr/bin/env bash

echo "Checking the debug JSON..."
if [ -f /tmp/working-test/debug-data.json ]; then
    echo "File exists"
    echo ""
    
    echo "First 2000 chars of readme_content:"
    jq -r '.readme_content' /tmp/working-test/debug-data.json | head -c 2000
    echo ""
    echo "..."
    echo ""
    
    echo "Checking for {{:"
    jq -r '.readme_content' /tmp/working-test/debug-data.json | grep -o "{{[^}]*}}" | head -10
    
    echo ""
    echo "Checking for &#123;:"
    jq -r '.readme_content' /tmp/working-test/debug-data.json | grep -o "&#123;&#123;[^&]*&#125;&#125;" | head -10
    
else
    echo "Debug JSON not found at /tmp/working-test/debug-data.json"
fi
