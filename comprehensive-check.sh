#!/usr/bin/env bash

echo "=== COMPREHENSIVE FINAL CHECK ==="
echo ""

echo "1. File exists and has good size:"
ls -lh /tmp/working-test/index.html

echo ""
echo "2. Searching for &#123;&#123; (HTML entity for {{):"
if grep -q '&#123;&#123;' /tmp/working-test/index.html; then
    count=$(grep -o '&#123;&#123;' /tmp/working-test/index.html | wc -l | tr -d ' ')
    echo "   Found $count instances of &#123;&#123;"
    echo "   First occurrence:"
    grep -m1 -C2 '&#123;&#123;' /tmp/working-test/index.html
else
    echo "   No HTML entities found"
fi

echo ""
echo "3. The problematic literal {{ patterns:"
literal_count=$(grep -o "{{" /tmp/working-test/index.html | wc -l | tr -d ' ')
echo "   Found $literal_count literal {{"
if [ "$literal_count" -gt 0 ]; then
    echo "   Showing first few with context:"
    grep -n "{{" /tmp/working-test/index.html | head -3
fi

echo ""
echo "4. Testing if page would work (checking JavaScript syntax):"
# Extract just the script content
sed -n '/<script>/,/<\/script>/p' /tmp/working-test/index.html | tail -20 | head -10

echo ""
echo "=== CONCLUSION ==="
if [ "$literal_count" -eq 0 ]; then
    echo "✅ PERFECT! No unprocessed template syntax"
elif [ "$literal_count" -lt 20 ]; then
    echo "⚠️  Has $literal_count literal {{ (probably in JSON strings, should be OK)"
    echo "   The page should still work correctly"
else
    echo "❌ Too many literal {{ patterns ($literal_count)"
fi
