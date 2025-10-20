#!/usr/bin/env bash

cd "$(dirname "$0")"
source ./leaf.sh 2>/dev/null

test='Test content'
echo "Input: $test"

# What jq produces
json_str=$(jq -n --arg text "$test" '$text')
echo "jq output: $json_str"
echo "Type: $(echo "$json_str" | jq -r 'type')"

# What happens with --argjson
result=$(jq -n --argjson val "$json_str" '{value: $val}')
echo "With --argjson:"
echo "$result"

# What the value is
value=$(echo "$result" | jq -r '.value')
echo "Extracted value: $value"
