#!/usr/bin/env bash

cd "$(dirname "$0")"
source ./leaf.sh 2>/dev/null

# Test with simple input
test='Test `code` here'
result=$(escape_myst_for_display "$test")

echo "Simple test:"
echo "Input:  $test"
echo "Output: $result"
echo ""

# Check each character
echo "Character by character:"
for ((i=0; i<${#result}; i++)); do
    char="${result:$i:1}"
    hex=$(printf '%s' "$char" | od -An -tx1 | tr -d ' ')
    echo "  [$i] '$char' (0x$hex)"
done
