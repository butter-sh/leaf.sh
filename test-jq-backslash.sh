#!/usr/bin/env bash

echo "Testing how jq handles escaped backticks..."
echo ""

test_input='Code: \`example\` here'
echo "Input string: $test_input"
echo ""

# Method 1: Using --arg
json1=$(jq -n --arg text "$test_input" '{content: $text}')
echo "Method 1 - Using --arg:"
echo "$json1"
extracted1=$(echo "$json1" | jq -r '.content')
echo "Extracted: $extracted1"
echo ""

# Method 2: Using --arg with double backslash
test_input2='Code: \\`example\\` here'
json2=$(jq -n --arg text "$test_input2" '{content: $text}')
echo "Method 2 - Double backslash in input:"
echo "Input: $test_input2"
echo "$json2"
extracted2=$(echo "$json2" | jq -r '.content')
echo "Extracted: $extracted2"
echo ""

echo "Summary:"
if [[ "$extracted1" == *'\`'* ]]; then
    echo "  Method 1: ✅ Preserved \\`"
else
    echo "  Method 1: ❌ Lost the backslash"
fi

if [[ "$extracted2" == *'\`'* ]]; then
    echo "  Method 2: ✅ Preserved \\`"
else
    echo "  Method 2: ❌ Lost the backslash"
fi
