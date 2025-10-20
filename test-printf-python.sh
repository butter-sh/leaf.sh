#!/usr/bin/env bash

test_input='Line 1: `code`
Line 2: `test`'

echo "Input:"
echo "$test_input"
echo ""

echo "Test 1: printf '%s' with pipe to Python"
result1=$(printf '%s' "$test_input" | python3 -c 'import sys; text = sys.stdin.read(); print(f"Read {len(text)} chars"); text = text.replace(chr(96), "\\" + chr(96)); sys.stdout.write(text)')
echo "Output:"
echo "$result1"
echo ""

echo "Test 2: Using cat and temp file"
tmpfile=$(mktemp)
printf '%s' "$test_input" > "$tmpfile"
result2=$(cat "$tmpfile" | python3 -c 'import sys; text = sys.stdin.read(); print(f"Read {len(text)} chars", file=sys.stderr); text = text.replace(chr(96), "\\" + chr(96)); sys.stdout.write(text)' 2>&1)
echo "Output:"
echo "$result2"
rm "$tmpfile"
