#!/usr/bin/env bash

test='Test `code` and {{author}}'
echo "Input: $test"

result=$(printf '%s' "$test" | python3 -c 'import sys; text = sys.stdin.read(); text = text.replace("{{", "&#123;&#123;").replace("}}", "&#125;&#125;").replace(chr(96), "\\" + chr(96)); sys.stdout.write(text)')

echo "Output: $result"
echo ""

if [[ "$result" == *'\`'* ]]; then
    echo "✅ Has escaped backticks"
else
    echo "❌ No escaped backticks"
fi

if [[ "$result" == *'&#123;&#123;'* ]]; then
    echo "✅ Has HTML entities"
else
    echo "❌ No HTML entities"
fi

echo ""
echo "Byte dump:"
printf '%s' "$result" | od -An -tx1c | head -5
