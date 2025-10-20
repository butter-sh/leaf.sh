#!/usr/bin/env bash

test_text="Author: {{author}}, Version: {{version}}"

echo "Original text:"
echo "$test_text"
echo ""

echo "Test 1 - Direct sed (current implementation):"
result1=$(printf '%s' "$test_text" | sed 's/{{/\&#123;\&#123;/g; s/}}/\&#125;\&#125;/g')
echo "$result1"
echo ""

echo "Test 2 - Using different quoting:"
result2=$(printf '%s' "$test_text" | sed "s/{{/\&#123;\&#123;/g; s/}}/\&#125;\&#125;/g")
echo "$result2"
echo ""

echo "Test 3 - Character class approach:"
result3=$(printf '%s' "$test_text" | sed 's/{/\&#123;/g; s/}/\&#125;/g')
echo "$result3"
echo ""

echo "Checking results:"
for i in 1 2 3; do
    varname="result$i"
    result="${!varname}"
    if echo "$result" | grep -q "&#123;"; then
        echo "  Test $i: ✅ Has HTML entities"
    else
        echo "  Test $i: ❌ No HTML entities"
    fi
    if echo "$result" | grep -q "{{"; then
        echo "  Test $i: ❌ Still has {{"
    else
        echo "  Test $i: ✅ No more {{"
    fi
done
