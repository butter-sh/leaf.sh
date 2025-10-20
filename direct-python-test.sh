#!/usr/bin/env bash

cd "$(dirname "$0")"

echo "Direct Python test:"
test='Code: `echo hello` with {{author}}'
echo "Input: $test"

result=$(python3 -c "import sys; text = sys.stdin.read(); text = text.replace('{{', '&#123;&#123;').replace('}}', '&#125;&#125;').replace('\`', r'\\\`'); sys.stdout.write(text)" <<< "$test")

echo "Output: $result"
echo ""

if [[ "$result" == *'\`'* ]]; then
    echo "✅ Contains escaped backtick"
else
    echo "❌ No escaped backtick"
fi

if [[ "$result" == *'&#123;&#123;'* ]]; then
    echo "✅ Contains HTML entities"
else
    echo "❌ No HTML entities"
fi
