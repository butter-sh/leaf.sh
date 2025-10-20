#!/usr/bin/env bash

echo "Checking the debug JSON to see what data was passed to myst:"
echo ""

if [ -f /tmp/working-test/debug-data.json ]; then
    echo "readme_content length:"
    jq -r '.readme_content | length' /tmp/working-test/debug-data.json
    
    echo ""
    echo "First 300 chars of readme_content:"
    jq -r '.readme_content' /tmp/working-test/debug-data.json | head -c 300
    
    echo ""
    echo ""
    echo "Last 300 chars of readme_content:"
    jq -r '.readme_content' /tmp/working-test/debug-data.json | tail -c 300
    
    echo ""
    echo ""
    echo "Checking for backticks in readme_content:"
    if jq -r '.readme_content' /tmp/working-test/debug-data.json | grep -q '`'; then
        echo "⚠️  Found backticks in content!"
        echo "Count: $(jq -r '.readme_content' /tmp/working-test/debug-data.json | grep -o '`' | wc -l)"
        echo "This could break the JavaScript template literal"
    else
        echo "✅ No backticks found"
    fi
else
    echo "No debug JSON found"
fi
