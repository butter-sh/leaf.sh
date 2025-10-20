#!/usr/bin/env bash

test='Code: `example`'
echo "Input: $test"
echo ""

# Current implementation
result=$(printf '%s' "$test" | python3 -c 'import sys; text = sys.stdin.read(); text = text.replace(chr(96), "\\\\" + chr(96)); sys.stdout.write(text)')
echo "Current (\\\\\\\\):"
echo "Output: $result"
echo "Hex: $(printf '%s' "$result" | od -An -tx1)"
echo ""

# What we actually need
result2=$(printf '%s' "$test" | python3 -c 'import sys; text = sys.stdin.read(); text = text.replace(chr(96), "\\\\\\\\" + chr(96)); sys.stdout.write(text)')
echo "Double (\\\\\\\\\\\\\\\\):"
echo "Output: $result2"
echo "Hex: $(printf '%s' "$result2" | od -An -tx1)"
echo ""

echo "Testing in bash variable:"
echo "Current var contains: ${result}"
echo "Double var contains: ${result2}"
