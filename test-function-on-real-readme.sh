#!/usr/bin/env bash

cd "$(dirname "$0")"

# Source the script
source ./leaf.sh 2>/dev/null

echo "Testing escape_myst_for_display function..."
echo ""

# Read actual README
readme=$(cat ../whip.sh/README.md)
echo "Original README length: ${#readme}"
echo "Original backtick count: $(echo "$readme" | grep -o '`' | wc -l)"
echo ""

# Apply escape
escaped=$(escape_myst_for_display "$readme")
echo "Escaped README length: ${#escaped}"
echo "Escaped backtick count (\\`): $(echo "$escaped" | grep -o '\\`' | wc -l || echo 0)"
echo "Unescaped backtick count: $(echo "$escaped" | grep -o '`' | wc -l || echo 0)"
echo ""

echo "Last 300 chars of escaped content:"
echo "${escaped: -300}"
