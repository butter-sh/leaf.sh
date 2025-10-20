#!/usr/bin/env bash
# Check what's actually in the generated HTML

echo "=== Checking Generated HTML ==="
echo ""

echo "1. Looking for source files section in HTML:"
grep -A 10 'id="source"' /tmp/test-rawfile/index.html
echo ""

echo "2. Checking the actual div content:"
sed -n '/<section id="source"/,/<\/section>/p' /tmp/test-rawfile/index.html | head -30
echo ""

echo "3. Checking debug JSON for source_files_html:"
if [ -f /tmp/test-rawfile/debug-data.json ]; then
    echo "First 500 chars of source_files_html in JSON:"
    jq -r '.source_files_html' /tmp/test-rawfile/debug-data.json | head -c 500
    echo ""
    echo "..."
fi
