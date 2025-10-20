#!/usr/bin/env bash

echo "Finding the JavaScript section with readmeContent..."
echo ""

if [ -f /tmp/working-test/index.html ]; then
    # Extract the script section with readmeContent
    sed -n '/const readmeContent/,/marked.parse/p' /tmp/working-test/index.html | head -20
    
    echo ""
    echo "==="
    echo ""
    echo "Last 200 chars of that variable:"
    sed -n '/const readmeContent = `/,/`;/p' /tmp/working-test/index.html | tail -c 200
else
    echo "No HTML file found"
fi
