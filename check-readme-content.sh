#!/usr/bin/env bash

echo "=== Checking README content in output ==="
echo ""

echo "1. Looking for the readmeContent JavaScript variable:"
if grep -q "const readmeContent" /tmp/working-test/index.html; then
    echo "   Found readmeContent variable"
    echo ""
    echo "   First 500 chars of that section:"
    sed -n '/const readmeContent = `/,/`;/p' /tmp/working-test/index.html | head -c 500
    echo ""
    echo "   ..."
    echo ""
    echo "   Last 500 chars:"
    sed -n '/const readmeContent = `/,/`;/p' /tmp/working-test/index.html | tail -c 500
    echo ""
else
    echo "   ❌ readmeContent variable not found"
fi

echo ""
echo "2. Checking if README div exists:"
if grep -q 'id="readmeContent"' /tmp/working-test/index.html; then
    echo "   ✅ Found readmeContent div"
else
    echo "   ❌ readmeContent div not found"
fi

echo ""
echo "3. Searching for any 'author' text (case insensitive):"
grep -i "author" /tmp/working-test/index.html | head -5

echo ""
echo "4. Looking at the actual size breakdown:"
echo "   Total file: $(wc -c < /tmp/working-test/index.html) bytes"
echo "   Total lines: $(wc -l < /tmp/working-test/index.html) lines"

echo ""
echo "5. Checking what's actually in the file:"
echo "   First 20 lines:"
head -20 /tmp/working-test/index.html

echo ""
echo "   Last 20 lines:"
tail -20 /tmp/working-test/index.html
