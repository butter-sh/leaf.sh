#!/usr/bin/env bash

cd "$(dirname "$0")"

echo "Testing with fixed templates..."
rm -rf /tmp/working-test

bash leaf.sh ../whip.sh -o /tmp/working-test 2>&1 | grep -E "(ℹ|✓|✗)"

echo ""
echo "Checking for unprocessed {{ patterns:"
count=$(grep -c "{{" /tmp/working-test/index.html || echo 0)
echo "Found: $count"

if [ "$count" -eq 0 ]; then
    echo "✅ SUCCESS: No unprocessed template syntax!"
else
    echo "❌ Still found {{ patterns:"
    grep -n "{{" /tmp/working-test/index.html
fi

echo ""
echo "Checking for {{author}} in README section:"
if grep -q "author" /tmp/working-test/index.html; then
    echo "Found 'author' in HTML:"
    grep -C2 "author" /tmp/working-test/index.html | head -10
fi
