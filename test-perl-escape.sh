#!/usr/bin/env bash

test='Code: `echo hello`'
echo "Input: $test"
echo ""

echo "Test 1: Perl with \\\\\\\\` (4 backslashes)"
result1=$(printf '%s' "$test" | perl -pe 's/`/\\\\`/g')
echo "Result: $result1"
echo "Length: ${#result1}"
echo ""

echo "Test 2: Perl with \\\\\\\\\\\\\\\\ ` (8 backslashes)"  
result2=$(printf '%s' "$test" | perl -pe 's/`/\\\\\\\\`/g')
echo "Result: $result2"
echo ""

echo "Checking in JavaScript context:"
for i in 1 2; do
    varname="result$i"
    result="${!varname}"
    echo "Test $i:"
    echo "  const x = \`$result\`;"
    
    # Count backslashes before backtick
    if [[ "$result" =~ \\+\` ]]; then
        echo "  Pattern found: ${BASH_REMATCH[0]}"
    fi
done
