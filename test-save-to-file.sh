#!/usr/bin/env bash

cd "$(dirname "$0")"
source ./leaf.sh 2>/dev/null

# Get actual README
readme=$(cat ../whip.sh/README.md)
echo "Original length: ${#readme}"

# Escape it
escaped=$(escape_myst_for_display "$readme")
echo "Escaped length: ${#escaped}"

# Save to file to check
tmpfile="/tmp/test-escaped-readme.txt"
printf '%s' "$escaped" > "$tmpfile"

echo "File size: $(wc -c < "$tmpfile") bytes"
echo ""

# Check file for escaped backticks
escaped_in_file=$(grep -o '\\`' "$tmpfile" | wc -l)
echo "Escaped backticks in file: $escaped_in_file"

# Check for unescaped backticks (not preceded by backslash)
# This is tricky - look for backticks that don't have a backslash before them
unescaped_in_file=$(grep -oP '(?<!\\)`' "$tmpfile" | wc -l)
echo "Unescaped backticks in file: $unescaped_in_file"

if [ "$escaped_in_file" -gt 50 ]; then
    echo "✅ File has properly escaped backticks!"
else
    echo "❌ File doesn't have enough escaped backticks"
    echo ""
    echo "First occurrence of backtick:"
    grep -n '`' "$tmpfile" | head -3
fi

rm "$tmpfile"
