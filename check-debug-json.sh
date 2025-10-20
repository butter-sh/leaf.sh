#!/usr/bin/env bash

echo "=== Checking debug JSON ==="
if [ -f /tmp/working-test/debug-data.json ]; then
    echo "Looking for {{author}} pattern in readme_content:"
    jq -r '.readme_content' /tmp/working-test/debug-data.json | grep -C2 "author"
    echo ""
    echo "=== Raw check for {{ ==="
    if jq -r '.readme_content' /tmp/working-test/debug-data.json | grep -q "{{"; then
        echo "❌ Found {{ in JSON"
        jq -r '.readme_content' /tmp/working-test/debug-data.json | grep "{{" | head -3
    else
        echo "✅ No {{ in JSON"
    fi
    echo ""
    echo "=== Raw check for &#123; ==="
    if jq -r '.readme_content' /tmp/working-test/debug-data.json | grep -q "&#123;"; then
        echo "✅ Found &#123; in JSON"
        jq -r '.readme_content' /tmp/working-test/debug-data.json | grep "&#123;" | head -3
    else
        echo "❌ No &#123; in JSON"
    fi
else
    echo "No debug JSON found"
fi
