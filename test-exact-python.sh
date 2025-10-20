#!/usr/bin/env bash

test='Test `code` here'
echo "Testing the exact Python command from the function:"
echo "Input: $test"
echo ""

result=$(printf '%s' "$test" | python3 -c 'import sys; text = sys.stdin.read(); text = text.replace(chr(96), "\\" + chr(96)); sys.stdout.write(text)')

echo "Output: $result"
echo "Length: ${#result}"
echo ""

# Check if it has the escaped backtick
if [[ "$result" =~ \\\` ]]; then
    echo "✅ Contains \\` (backslash-backtick)"
else
    echo "❌ Does NOT contain \\` "
    echo "Hex dump:"
    printf '%s' "$result" | od -An -tx1c
fi
