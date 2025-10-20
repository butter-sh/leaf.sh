#!/usr/bin/env bash

cd "$(dirname "$0")"

# Source the script to get the function
source ./leaf.sh 2>/dev/null || true

# Test the function
test_input="## Author

{{author}}"

echo "Input:"
echo "$test_input"
echo ""

output=$(escape_myst_for_display "$test_input")

echo "Output from escape_myst_for_display:"
echo "$output"
echo ""

echo "Checking output:"
if echo "$output" | grep -q "&#123;"; then
    echo "✅ Contains HTML entities"
    echo "  Found: $(echo "$output" | grep -o "&#123;&#123;[^&]*&#125;&#125;")"
else
    echo "❌ No HTML entities found"
fi

if echo "$output" | grep -q "{{"; then
    echo "❌ Still contains {{"
else
    echo "✅ No {{ remaining"
fi
