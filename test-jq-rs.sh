#!/usr/bin/env bash

test="Test content"
echo "Input: $test"

result=$(printf '%s' "$test" | jq -Rs '.')
echo "Result from jq -Rs: $result"
echo "Length: ${#result}"

# Check if it starts with quote
if [[ "$result" == \"* ]]; then
    echo "✅ Starts with quote"
else
    echo "❌ Does NOT start with quote"
    echo "First char: ${result:0:1}"
fi
