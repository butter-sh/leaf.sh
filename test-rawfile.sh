#!/usr/bin/env bash
# Quick test of --rawfile behavior

echo "Testing jq --rawfile..."

# Create test file
echo -n "<div>Test HTML</div>" > /tmp/test-raw.txt

# Test with --rawfile
result=$(jq -n --rawfile html /tmp/test-raw.txt '{html: $html}')

echo "Result:"
echo "$result"

echo ""
echo "Value of html field:"
echo "$result" | jq -r '.html'

rm /tmp/test-raw.txt
