#!/usr/bin/env bash

cd "$(dirname "$0")"

echo "Regenerating with debug..."
bash leaf.sh ../whip.sh -o /tmp/working-test 2>&1 | grep -E "(ℹ|✓|✗)"

echo ""
echo "Checking debug-data.json for escaped content:"
if [ -f /tmp/working-test/debug-data.json ]; then
    echo ""
    echo "readme_content field (first 500 chars):"
    jq -r '.readme_content' /tmp/working-test/debug-data.json | head -c 500
    echo ""
    echo ""
    echo "Searching for &#123; in JSON:"
    if grep -q "&#123;" /tmp/working-test/debug-data.json; then
        echo "✅ Found HTML entities in JSON"
        grep -o "&#123;&#123;[^&]*&#125;&#125;" /tmp/working-test/debug-data.json | head -5
    else
        echo "❌ No HTML entities in JSON"
    fi
    echo ""
    echo "Searching for {{ in JSON:"
    if grep -q "{{" /tmp/working-test/debug-data.json; then
        echo "❌ Still has {{ in JSON"
        grep -o "{{[^}]*}}" /tmp/working-test/debug-data.json | head -5
    else
        echo "✅ No {{ in JSON"
    fi
else
    echo "❌ debug-data.json not found"
fi
