#!/usr/bin/env bash
# Debug the JSON generation

echo "Checking generated JSON data..."
echo ""

if [ -f /tmp/test-final-slurpfile/debug-data.json ]; then
    echo "1. Checking if source_files_html field exists:"
    jq 'has("source_files_html")' /tmp/test-final-slurpfile/debug-data.json
    
    echo ""
    echo "2. Type of source_files_html:"
    jq '.source_files_html | type' /tmp/test-final-slurpfile/debug-data.json
    
    echo ""
    echo "3. Length of source_files_html:"
    jq '.source_files_html | length' /tmp/test-final-slurpfile/debug-data.json
    
    echo ""
    echo "4. First 200 chars of source_files_html:"
    jq -r '.source_files_html' /tmp/test-final-slurpfile/debug-data.json | head -c 200
    echo ""
    
    echo ""
    echo "5. Checking in the HTML file:"
    grep -o 'source files' /tmp/test-final-slurpfile/index.html || echo "Pattern not found"
    
    echo ""
    echo "6. Looking for the actual div with source files:"
    grep -A 5 'id="source"' /tmp/test-final-slurpfile/index.html | head -20
else
    echo "Debug JSON not found!"
fi
