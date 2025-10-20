#!/usr/bin/env bash
# Test to see what's in the actual temp file

cd ~/Projects/butter.sh/projects/whip.sh

# Generate again with debug
bash ../leaf.sh/leaf.sh . -o /tmp/test-check 2>&1 | grep "source files"

echo ""
echo "Checking temp file (if it still exists)..."
ls -lh /tmp/leaf_src_*.txt 2>/dev/null | head -1

echo ""
echo "First 1000 chars of the generated source HTML from JSON:"
jq -r '.source_files_html' /tmp/test-check/debug-data.json | head -c 1000

echo ""
echo ""
echo "Counting newlines in source_files_html:"
jq -r '.source_files_html' /tmp/test-check/debug-data.json | wc -l

echo ""
echo "Looking at the actual structure:"
jq -r '.source_files_html' /tmp/test-check/debug-data.json | head -20
