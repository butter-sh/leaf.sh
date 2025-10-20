#!/usr/bin/env bash

cd "$(dirname "$0")"

echo "=== DEBUGGING THE FULL PIPELINE ==="
echo ""

# Source the function
source ./leaf.sh 2>/dev/null

# Step 1: Get raw README
readme_raw=$(cat ../whip.sh/README.md)
echo "1. Raw README length: ${#readme_raw} chars"
echo "   Backtick count: $(echo "$readme_raw" | grep -o '`' | wc -l)"
echo ""

# Step 2: Escape it
readme_escaped=$(escape_myst_for_display "$readme_raw")
echo "2. After escape_myst_for_display:"
echo "   Length: ${#readme_escaped} chars"
echo "   Backtick (unescaped) count: $(echo "$readme_escaped" | grep -o '`' | grep -v '\\' | wc -l || echo 0)"
echo "   Last 200 chars:"
echo "${readme_escaped: -200}"
echo ""

# Step 3: Pass through jq
json_file="/tmp/test-jq-pipeline.json"
jq -n --arg readme "$readme_escaped" '{readme_content: $readme}' > "$json_file"
echo "3. After jq processing:"
echo "   JSON file size: $(wc -c < "$json_file") bytes"
echo "   readme_content length: $(jq -r '.readme_content | length' "$json_file")"
echo "   Last 200 chars from JSON:"
jq -r '.readme_content' "$json_file" | tail -c 200
echo ""

rm -f "$json_file"
