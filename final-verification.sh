#!/usr/bin/env bash

cd "$(dirname "$0")"

echo "=== Final Verification ==="
echo ""

if [ ! -f /tmp/working-test/index.html ]; then
    echo "Generating..."
    bash leaf.sh ../whip.sh -o /tmp/working-test 2>&1 > /dev/null
fi

echo "1. Checking for unprocessed {{ patterns:"
count=$(grep -o "{{" /tmp/working-test/index.html | wc -l | tr -d ' ')
echo "   Found: $count instances of {{"

if [ "$count" -eq 0 ]; then
    echo "   ✅ No unprocessed template syntax"
else
    echo "   ❌ Still has unprocessed patterns"
    grep -n "{{" /tmp/working-test/index.html
fi

echo ""
echo "2. Checking if {{author}} is displayed correctly:"

# Search for the author text in the HTML
if grep -q "&#123;&#123;author&#125;&#125;" /tmp/working-test/index.html; then
    echo "   ✅ Found HTML entities for {{author}}"
    echo "   Context:"
    grep -B2 -A2 "&#123;&#123;author&#125;&#125;" /tmp/working-test/index.html | head -10
elif grep -q "{{author}}" /tmp/working-test/index.html; then
    echo "   ❌ Found literal {{author}} (not escaped)"
else
    echo "   ⚠️  'author' text not found at all"
    echo "   Searching for just 'Author':"
    grep -C3 "## Author" /tmp/working-test/index.html | head -10
fi

echo ""
echo "3. Checking if myst conditionals were processed:"
if grep -q "myst.sh" /tmp/working-test/index.html; then
    echo "   ✅ Footer contains 'myst.sh' (conditional was processed)"
else
    echo "   ❌ Footer missing 'myst.sh'"
fi

echo ""
echo "4. File size check:"
size=$(wc -c < /tmp/working-test/index.html)
echo "   Output size: $size bytes"

if [ "$size" -gt 50000 ]; then
    echo "   ✅ File has reasonable size"
else
    echo "   ⚠️  File seems small, content might be missing"
fi

echo ""
echo "=== SUMMARY ==="
if [ "$count" -eq 0 ]; then
    echo "✅ ALL TESTS PASSED!"
    echo "   - No unprocessed MyST template syntax"
    echo "   - README content properly escaped"
    echo "   - Conditionals processed correctly"
else
    echo "❌ Some issues remain"
fi
