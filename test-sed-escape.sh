#!/usr/bin/env bash

# Test the sed command directly

test_text="Author: {{author}}, Version: {{version}}"

echo "Original:"
echo "$test_text"
echo ""

echo "Method 1 - Basic replacement:"
echo "$test_text" | sed 's/{{/LEFTBRACE/g; s/}}/RIGHTBRACE/g'
echo ""

echo "Method 2 - HTML entities (escaped for sed):"
echo "$test_text" | sed 's/{{/\&#123;\&#123;/g; s/}}/\&#125;\&#125;/g'
echo ""

echo "Method 3 - HTML entities (different escaping):"
echo "$test_text" | sed 's/{{/\&\#123;\&\#123;/g; s/}}/\&\#125;\&\#125;/g'
echo ""

echo "Method 4 - Test in printf:"
result=$(printf '%s' "$test_text" | sed 's/{{/\&\#123;\&\#123;/g; s/}}/\&\#125;\&\#125;/g')
echo "$result"
