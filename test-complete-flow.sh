#!/usr/bin/env bash

cd "$(dirname "$0")"

echo "=== Testing the complete flow step by step ==="
echo ""

# Manually do what generate_docs_page does
source ./leaf.sh 2>/dev/null

# Read README
readme_raw=$(cat ../whip.sh/README.md)
echo "1. Raw README: ${#readme_raw} chars, $(echo "$readme_raw" | grep -o '`' | wc -l) backticks"

# Escape it
readme_escaped=$(escape_myst_for_display "$readme_raw")
echo "2. Escaped README: ${#readme_escaped} chars"

# Count escaped vs unescaped backticks carefully
# Escaped backticks are \` (backslash followed by backtick)
escaped_count=$(printf '%s' "$readme_escaped" | grep -o '\\`' | wc -l | tr -d ' ')
# Total backticks (including escaped ones)
total_backtick_bytes=$(printf '%s' "$readme_escaped" | grep -o '`' | wc -l | tr -d ' ')

echo "   Escaped backticks (\\`): $escaped_count"
echo "   Total backtick bytes: $total_backtick_bytes"
echo "   (Should be roughly double if all are escaped)"

if [ "$escaped_count" -gt 50 ]; then
    echo "   ✅ Escaping worked!"
else
    echo "   ❌ Escaping failed - not enough escaped backticks"
    echo ""
    echo "   Sample of first 500 chars:"
    printf '%s' "${readme_escaped:0:500}"
fi
