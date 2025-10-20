#!/usr/bin/env bash

echo "=== Checking what jq actually put in the JSON ==="
if [ -f /tmp/working-test/debug-data.json ]; then
    echo ""
    echo "1. readme_content field length:"
    length=$(jq -r '.readme_content | length' /tmp/working-test/debug-data.json)
    echo "   $length characters"
    
    echo ""
    echo "2. First 500 chars of readme_content:"
    jq -r '.readme_content' /tmp/working-test/debug-data.json | head -c 500
    
    echo ""
    echo ""
    echo "3. Last 500 chars:"
    jq -r '.readme_content' /tmp/working-test/debug-data.json | tail -c 500
    
    echo ""
    echo ""
    echo "4. Checking for escaped patterns:"
    escaped_backticks=$(jq -r '.readme_content' /tmp/working-test/debug-data.json 2>/dev/null | grep -o '\\`' | wc -l | tr -d ' ')
    echo "   Escaped backticks (\\`): $escaped_backticks"
    
    html_entities=$(jq -r '.readme_content' /tmp/working-test/debug-data.json 2>/dev/null | grep -o '&#123;&#123;' | wc -l | tr -d ' ')
    echo "   HTML entities: $html_entities"
    
    echo ""
    echo "5. Raw JSON inspection (looking at actual file bytes):"
    # Look for backslash-backtick pattern in raw JSON
    if grep -q '\\`' /tmp/working-test/debug-data.json; then
        echo "   ✅ Found \\` in raw JSON file"
        count=$(grep -o '\\`' /tmp/working-test/debug-data.json | wc -l | tr -d ' ')
        echo "   Count: $count"
    else
        echo "   ❌ No \\` in raw JSON file"
    fi
else
    echo "No debug JSON found"
fi
