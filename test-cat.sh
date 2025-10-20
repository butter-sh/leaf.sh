#!/usr/bin/env bash
# test-cat.sh - Test if cat is working

cd "$(dirname "${BASH_SOURCE[0]}")"

test_file="../whip.sh/setup.sh"

echo "Test 1: Direct cat"
cat "$test_file" | head -5
echo ""

echo "Test 2: Cat into variable"
content=$(cat "$test_file")
echo "Length: ${#content}"
echo "First 100 chars: ${content:0:100}"
echo ""

echo "Test 3: Using escape_html function"
source <(grep -A 10 "^escape_html()" leaf.sh | sed '/^}/q')

escaped=$(cat "$test_file" | escape_html)
echo "Escaped length: ${#escaped}"
echo "First 100 chars: ${escaped:0:100}"
echo ""

echo "Test 4: Two-step approach"
content=$(cat "$test_file")
echo "Content length: ${#content}"
if [[ -n "$content" ]]; then
    escaped=$(echo "$content" | escape_html)
    echo "Escaped length: ${#escaped}"
else
    echo "Content is empty!"
fi
