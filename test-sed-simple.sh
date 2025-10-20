#!/usr/bin/env bash

# Direct test of the sed pattern
echo "Testing sed pattern directly:"
echo ""

input="Author: {{author}}"
echo "Input: $input"
echo ""

# Test the exact sed command from the function
output=$(printf '%s' "$input" | sed 's/{{/\&#123;\&#123;/g; s/}}/\&#125;\&#125;/g')
echo "Output: $output"
echo ""

# Check what we got
if [[ "$output" == *"&#123;&#123;"* ]]; then
    echo "✅ SUCCESS: sed produced HTML entities"
else
    echo "❌ FAILED: sed did not produce HTML entities"
    echo "Output bytes:"
    printf '%s' "$output" | od -c
fi
