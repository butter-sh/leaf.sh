#!/usr/bin/env bash

echo "Checking what the 3 instances of {{ actually are..."
echo ""

grep -n "{{" /tmp/working-test/index.html

echo ""
echo "=== Detailed view ==="

# Get each line number and show it
while IFS=: read -r line_num content; do
    echo "Line $line_num:"
    echo "$content"
    echo ""
done < <(grep -n "{{" /tmp/working-test/index.html)
