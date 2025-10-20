#!/usr/bin/env bash

echo "Testing backtick escaping in sed..."
echo ""

test_input='Code: `echo hello` and `date`'
echo "Input:"
echo "$test_input"
echo ""

# Try different escaping approaches
echo "Test 1: s/\`/\\\\\\\\\`/g (4 backslashes)"
result1=$(printf '%s' "$test_input" | sed 's/`/\\\\`/g')
echo "Result: $result1"
echo "Bytes: $(printf '%s' "$result1" | od -An -tx1)"
echo ""

echo "Test 2: Using double quotes with escaping"
result2=$(printf '%s' "$test_input" | sed "s/\`/\\\\\\\\\`/g")
echo "Result: $result2"
echo ""

echo "Test 3: Simpler approach with printf"
result3=$(printf '%s' "$test_input" | sed 's/`/\\\\&/g')
echo "Result: $result3"
echo ""

echo "What we need in JavaScript:"
echo 'const x = `Code: \`echo hello\` and \`date\``;'
echo ""

echo "Which test produces that?"
for i in 1 2 3; do
    varname="result$i"
    result="${!varname}"
    js_string="const x = \`$result\`;"
    echo "Test $i in JS context:"
    echo "$js_string"
    
    # Try to validate it
    if node -e "$js_string; console.log(x);" 2>/dev/null; then
        echo "  ✅ Valid JavaScript!"
    else
        echo "  ❌ Invalid JavaScript"
    fi
    echo ""
done
