#!/usr/bin/env bash

cd "$(dirname "$0")"
source ./leaf.sh 2>/dev/null

# Simple test
test='Test {{author}} here'
echo "Input: $test"

# Step 1: Escape for display
escaped=$(escape_myst_for_display "$test")
echo "After escape_myst_for_display: $escaped"

# Step 2: Create JSON like leaf.sh does
json_version=$(jq -n --arg text "$escaped" '$text')
echo "After jq JSON encoding: $json_version"

# Step 3: What would be in the final JSON
final_json=$(jq -n --arg readme_json "$json_version" '{readme_content_json: $readme_json}')
echo "Final JSON:"
echo "$final_json"

echo ""
echo "Checking:"
if echo "$final_json" | grep -q '&#123;&#123;'; then
    echo "✅ Has HTML entities"
else
    echo "❌ No HTML entities"
fi
