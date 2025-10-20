#!/usr/bin/env bash
# Diagnose what's in the JSON and what MyST is outputting

cd ~/Projects/butter.sh/projects/whip.sh

echo "Generating docs with debug..."
bash ../leaf.sh/leaf.sh . -o ./docs-test --debug 2>&1 | tail -5

echo ""
echo "Checking debug-data.json..."
if [ -f ./docs-test/debug-data.json ]; then
    echo ""
    echo "1. Type of readme_content_json:"
    jq -r '.readme_content_json | type' ./docs-test/debug-data.json
    
    echo ""
    echo "2. First 200 characters of readme_content_json VALUE:"
    jq -r '.readme_content_json' ./docs-test/debug-data.json | head -c 200
    echo ""
    
    echo ""
    echo "3. First 200 characters of readme_content_json RAW (with quotes):"
    jq '.readme_content_json' ./docs-test/debug-data.json | head -c 200
    echo ""
    
    echo ""
    echo "4. What's in the generated HTML at line 105:"
    sed -n '105p' ./docs-test/index.html
    
    echo ""
    echo "5. The issue:"
    echo "   MyST with {{var}} outputs the STRING VALUE without quotes"
    echo "   But we NEED the quotes for valid JavaScript!"
fi
