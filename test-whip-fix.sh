#!/usr/bin/env bash
# Quick test on the actual whip.sh project

echo "Testing leaf.sh fix on whip.sh project..."
echo ""

cd ~/Projects/butter.sh/projects/whip.sh

# Generate docs
echo "Generating documentation..."
bash ../leaf.sh/leaf.sh . -o /tmp/whip-test-docs --debug 2>&1 | tail -10

echo ""
echo "Checking generated HTML..."

if [ ! -f /tmp/whip-test-docs/index.html ]; then
    echo "❌ Failed to generate index.html"
    exit 1
fi

echo "✅ index.html generated"
echo ""

# Find the problematic line
echo "Checking line 105 and surrounding context..."
sed -n '103,107p' /tmp/whip-test-docs/index.html | cat -n
echo ""

# Validate JavaScript if Node.js is available
if command -v node >/dev/null 2>&1; then
    echo "Validating JavaScript syntax..."
    sed -n '/<script>/,/<\/script>/p' /tmp/whip-test-docs/index.html | sed '1d;$d' > /tmp/whip-test.js
    
    if node --check /tmp/whip-test.js 2>&1; then
        echo "✅ JavaScript syntax is VALID!"
        echo ""
        echo "SUCCESS! The fix works correctly."
        echo ""
        echo "You can view the generated documentation at:"
        echo "file:///tmp/whip-test-docs/index.html"
    else
        echo "❌ JavaScript syntax error still present"
        echo ""
        echo "First 20 lines of generated JavaScript:"
        head -20 /tmp/whip-test.js
        exit 1
    fi
else
    echo "⚠️  Node.js not available - manual browser test required"
    echo ""
    echo "Open this file in a browser and check the console:"
    echo "file:///tmp/whip-test-docs/index.html"
fi
