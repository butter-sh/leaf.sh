#!/usr/bin/env bash

# Test what jq does with HTML entities
echo "Testing jq handling of HTML entities..."
echo ""

test_text="Author: &#123;&#123;author&#125;&#125;"

echo "Input: $test_text"
echo ""

# Method 1: Using --arg
json1=$(jq -n --arg text "$test_text" '{content: $text}')
echo "Using --arg:"
echo "$json1"
extracted1=$(echo "$json1" | jq -r '.content')
echo "Extracted back: $extracted1"
echo ""

# Check if it preserved the entities
if [[ "$extracted1" == "$test_text" ]]; then
    echo "✅ --arg preserves HTML entities"
else
    echo "❌ --arg changed the content"
    echo "Expected: $test_text"
    echo "Got: $extracted1"
fi
