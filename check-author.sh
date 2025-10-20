#!/usr/bin/env bash

echo "Checking for author in the JavaScript:"
echo ""

# Look in the JSON data
if grep -q 'author' /tmp/working-test/index.html; then
    echo "Found 'author' in HTML"
    grep -C3 'author' /tmp/working-test/index.html | head -20
else
    echo "No 'author' found"
fi

echo ""
echo "Checking readmeContent variable:"
sed -n '/const readmeContent/,/marked.parse/p' /tmp/working-test/index.html | head -5
