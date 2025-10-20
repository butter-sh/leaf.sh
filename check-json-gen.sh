#!/usr/bin/env bash
# check-json-gen.sh - Check JSON generation

cd "$(dirname "${BASH_SOURCE[0]}")"

echo "Testing JSON generation..."
echo ""

# Test the data_file variable expansion
echo "Test 1: Variable expansion"
echo "PID: $$"
data_file="/tmp/leaf_docs_$$.json"
echo "Should be: $data_file"
echo ""

# Clean up old files
rm -f /tmp/leaf_docs_*.json

# Generate with a single file test
echo "Test 2: Generating docs..."
bash leaf.sh ../whip.sh -o /tmp/json-test 2>&1 | grep -E "(Using myst|JSON file|Documentation generated)"

echo ""
echo "Test 3: Looking for JSON files..."
ls -lah /tmp/leaf_docs_*.json 2>/dev/null || echo "No JSON files found"

echo ""
echo "Test 4: Check if JSON is valid..."
for f in /tmp/leaf_docs_*.json; do
    if [[ -f "$f" ]]; then
        echo "File: $f"
        echo "First line:"
        head -1 "$f"
        echo ""
        if jq empty "$f" 2>/dev/null; then
            echo "✅ Valid JSON"
        else
            echo "❌ Invalid JSON"
            echo "Error:"
            jq empty "$f" 2>&1 | head -5
        fi
    fi
done
