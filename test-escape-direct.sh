#!/usr/bin/env bash

cd "$(dirname "$0")"

# Test the escape function directly
source ./leaf.sh

test_input="This has {{author}} and {{version}} in it."

echo "Input:"
echo "$test_input"
echo ""

echo "Output from escape_myst_for_display:"
result=$(escape_myst_for_display "$test_input")
echo "$result"
echo ""

echo "Checking if it contains HTML entities:"
if echo "$result" | grep -q "&#123;"; then
    echo "✅ Contains &#123; (good!)"
else
    echo "❌ Does NOT contain &#123; (bad!)"
fi

if echo "$result" | grep -q "{{"; then
    echo "❌ Still contains {{ (bad!)"
else
    echo "✅ Does NOT contain {{ (good!)"
fi
