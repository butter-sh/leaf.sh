#!/usr/bin/env bash

echo "Checking what's in the JSON data..."
if [ -f /tmp/working-test/debug-data.json ]; then
    echo ""
    echo "1. Looking for escaped backticks in JSON:"
    if jq -r '.readme_content' /tmp/working-test/debug-data.json | grep -q '\\`'; then
        echo "   ✅ Found \\` in JSON"
        count=$(jq -r '.readme_content' /tmp/working-test/debug-data.json | grep -o '\\`' | wc -l | tr -d ' ')
        echo "   Count: $count"
    else
        echo "   ❌ No \\` in JSON"
        echo "   Sample from JSON:"
        jq -r '.readme_content' /tmp/working-test/debug-data.json | head -c 300
    fi
    
    echo ""
    echo "2. Looking for HTML entities in JSON:"
    if jq -r '.readme_content' /tmp/working-test/debug-data.json | grep -q '&#123;&#123;'; then
        echo "   ✅ Found &#123;&#123; in JSON"
    else
        echo "   ❌ No &#123;&#123; in JSON"
    fi
    
    echo ""
    echo "3. Checking for unescaped backticks:"
    backtick_count=$(jq -r '.readme_content' /tmp/working-test/debug-data.json | grep -o '`' | wc -l | tr -d ' ')
    echo "   Found $backtick_count unescaped backticks"
    
    if [ "$backtick_count" -gt 0 ]; then
        echo "   ⚠️  These will break the JavaScript!"
        echo "   First occurrence context:"
        jq -r '.readme_content' /tmp/working-test/debug-data.json | grep -m1 -C2 '`'
    fi
else
    echo "No debug JSON found"
fi
