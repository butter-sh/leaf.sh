#!/usr/bin/env bash
# Diagnose the exact issue

cd ~/Projects/butter.sh/projects/whip.sh

if [ -f ./docs-test/debug-data.json ]; then
    echo "Checking debug-data.json..."
    echo ""
    
    echo "1. Raw readme_content_json field:"
    jq '.readme_content_json' ./docs-test/debug-data.json | head -c 300
    echo ""
    echo ""
    
    echo "2. Type:"
    jq '.readme_content_json | type' ./docs-test/debug-data.json
    echo ""
    
    echo "3. First 200 chars of the VALUE (unquoted):"
    jq -r '.readme_content_json' ./docs-test/debug-data.json | head -c 200
    echo ""
fi

echo ""
echo "4. What's in the HTML at line 105:"
LINE=$(grep -n "const readmeContent" ./docs-test/index.html | head -1 | cut -d: -f1)
sed -n "${LINE}p" ./docs-test/index.html | head -c 300
echo ""
