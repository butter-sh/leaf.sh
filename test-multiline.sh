#!/usr/bin/env bash

cd "$(dirname "$0")"

echo "Testing escape function with multiline input containing backticks..."
echo ""

# Create test input with newlines and backticks
test_input='Line 1 with `code`
Line 2 with `more`
Line 3 normal'

echo "Input (3 lines):"
echo "$test_input"
echo ""

# Method 1: Direct function call (how it's used in leaf.sh)
source ./leaf.sh 2>/dev/null
result1=$(escape_myst_for_display "$test_input")
echo "Method 1 - Function call:"
echo "Length: ${#result1}"
echo "Output:"
echo "$result1"
echo ""

# Method 2: Via pipe
result2=$(echo "$test_input" | escape_myst_for_display)
echo "Method 2 - Via pipe:"
echo "Length: ${#result2}"
echo "Output:"
echo "$result2"
echo ""

# Check both
for i in 1 2; do
    varname="result$i"
    result="${!varname}"
    if echo "$result" | grep -q '\\`'; then
        echo "Method $i: ✅ Has escaped backticks"
    else
        echo "Method $i: ❌ No escaped backticks found"
    fi
done
