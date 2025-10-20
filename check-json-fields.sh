#!/usr/bin/env bash

echo "Checking debug JSON for the escaped patterns:"
echo ""

if [ -f /tmp/working-test/debug-data.json ]; then
    echo "1. Does readme_content have &#123;&#123; ?"
    if jq -r '.readme_content' /tmp/working-test/debug-data.json | grep -q '&#123;&#123;'; then
        echo "   ✅ YES in readme_content"
        count=$(jq -r '.readme_content' /tmp/working-test/debug-data.json | grep -o '&#123;&#123;' | wc -l)
        echo "   Count: $count"
    else
        echo "   ❌ NO in readme_content"
    fi
    
    echo ""
    echo "2. Does readme_content_json have &#123;&#123; ?"
    if jq -r '.readme_content_json' /tmp/working-test/debug-data.json 2>/dev/null | grep -q '&#123;&#123;'; then
        echo "   ✅ YES in readme_content_json"
        count=$(jq -r '.readme_content_json' /tmp/working-test/debug-data.json | grep -o '&#123;&#123;' | wc -l)
        echo "   Count: $count"
    else
        echo "   ❌ NO in readme_content_json"
    fi
    
    echo ""
    echo "3. Last 300 chars of readme_content_json:"
    jq -r '.readme_content_json' /tmp/working-test/debug-data.json 2>/dev/null | tail -c 300
    
    echo ""
    echo ""
    echo "4. Checking what readme_content_json actually is:"
    jq -r '.readme_content_json | type' /tmp/working-test/debug-data.json 2>/dev/null
    echo "   Length: $(jq -r '.readme_content_json | length' /tmp/working-test/debug-data.json 2>/dev/null)"
else
    echo "No debug JSON"
fi
