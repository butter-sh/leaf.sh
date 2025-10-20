#!/usr/bin/env bash

echo "Checking what's in debug-data.json:"
if [ -f /tmp/working-test/debug-data.json ]; then
    echo ""
    echo "Type of readme_content_json:"
    jq -r '.readme_content_json | type' /tmp/working-test/debug-data.json
    
    echo ""
    echo "First 100 chars:"
    jq -r '.readme_content_json' /tmp/working-test/debug-data.json | head -c 100
    
    echo ""
    echo ""
    echo "Is it a quoted string?"
    jq '.readme_content_json' /tmp/working-test/debug-data.json | head -c 100
else
    echo "No JSON file"
fi
