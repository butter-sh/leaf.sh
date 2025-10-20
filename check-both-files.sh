#!/usr/bin/env bash

echo "=== Checking the JSON file ==="
if [ -f /tmp/working-test/debug-data.json ]; then
    echo "Searching for 'author' in readme_content:"
    jq -r '.readme_content' /tmp/working-test/debug-data.json | tail -20 | grep -A2 -B2 "author"
    echo ""
    echo "Raw JSON around author (using grep on file):"
    grep -o ".{50}author.{50}" /tmp/working-test/debug-data.json | head -1
else
    echo "No debug JSON"
fi

echo ""
echo "=== Checking the HTML output ==="
echo "Lines with {{ pattern:"
grep -n "{{" /tmp/working-test/index.html

echo ""
echo "Context around those lines:"
grep -B2 -A2 "{{" /tmp/working-test/index.html | head -30
