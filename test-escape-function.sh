#!/usr/bin/env bash

cd "$(dirname "$0")"

echo "Testing the escape function directly:"
echo ""

# Source it
source ./leaf.sh 2>/dev/null

# Test input with backticks
test_input='Code block: `echo hello` and `date`'
echo "Input:"
echo "$test_input"
echo ""

# Run the function
output=$(escape_myst_for_display "$test_input")

echo "Output:"
echo "$output"
echo ""

echo "Checking output:"
if echo "$output" | grep -q '\\`'; then
    echo "✅ Has escaped backticks"
    echo "Count: $(echo "$output" | grep -o '\\`' | wc -l)"
else
    echo "❌ No escaped backticks found"
fi

echo ""
echo "Byte dump of output:"
printf '%s' "$output" | od -An -tx1c | head -20
