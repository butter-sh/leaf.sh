#!/usr/bin/env bash

echo "=== Analyzing actual generated HTML ==="
echo ""

if [ ! -f /tmp/working-test/index.html ]; then
    echo "Generating fresh output..."
    bash leaf.sh ../whip.sh -o /tmp/working-test 2>&1 | grep -E "(ℹ|✓)"
    echo ""
fi

echo "File size: $(wc -c < /tmp/working-test/index.html) bytes"
echo ""

echo "Lines containing {{:"
grep -n "{{" /tmp/working-test/index.html
echo ""

echo "Full context around those lines:"
for line_num in $(grep -n "{{" /tmp/working-test/index.html | cut -d: -f1); do
    echo "=== Line $line_num ==="
    sed -n "$((line_num-5)),$((line_num+5))p" /tmp/working-test/index.html
    echo ""
done

echo ""
echo "Searching for 'Author' in the HTML:"
grep -n "Author" /tmp/working-test/index.html | head -5
echo ""

echo "Context around Author:"
grep -B3 -A3 "Author" /tmp/working-test/index.html | head -20
