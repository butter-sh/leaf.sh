#!/usr/bin/env bash

cd "$(dirname "$0")"

# Source the function
source ./leaf.sh 2>/dev/null

# Read the actual whip.sh README
readme=$(cat ../whip.sh/README.md)

echo "Original README (last 500 chars, where {{author}} should be):"
echo "${readme: -500}"
echo ""
echo "========================"
echo ""

# Apply the escape function
escaped=$(escape_myst_for_display "$readme")

echo "After escape_myst_for_display (last 500 chars):"
echo "${escaped: -500}"
echo ""
echo "========================"
echo ""

# Check for patterns
if echo "$escaped" | grep -q "{{"; then
    echo "❌ FAIL: Still contains {{"
    echo "Occurrences:"
    echo "$escaped" | grep -o "{{[^}]*}}"
else
    echo "✅ PASS: No {{ remaining"
fi

echo ""

if echo "$escaped" | grep -q "&#123;&#123;"; then
    echo "✅ PASS: Contains HTML entities"
    echo "Occurrences:"
    echo "$escaped" | grep -o "&#123;&#123;[^&]*&#125;&#125;"
else
    echo "❌ FAIL: No HTML entities found"
fi
