#!/usr/bin/env bash
# Test the JSON script tag approach

echo "Testing the JSON script tag fix..."
echo ""

cd ~/Projects/butter.sh/projects/whip.sh

# Clean previous output
rm -rf ./docs-final 2>/dev/null

# Generate
echo "Generating documentation..."
bash ../leaf.sh/leaf.sh . -o ./docs-final 2>&1 | tail -3

echo ""
echo "Checking the generated HTML structure..."
echo ""

# Check for the JSON script tag
if grep -q '<script id="readmeData" type="application/json">' ./docs-final/index.html; then
    echo "✅ Found JSON script tag"
else
    echo "❌ JSON script tag not found"
    exit 1
fi

# Check for the JavaScript that reads it
if grep -q 'JSON.parse(readmeData.textContent)' ./docs-final/index.html; then
    echo "✅ Found JSON.parse code"
else
    echo "❌ JSON.parse code not found"
    exit 1
fi

echo ""
echo "Validating JavaScript syntax..."

if command -v node >/dev/null 2>&1; then
    # Extract only the executable script (not the JSON data script)
    sed -n '/<script>/,/<\/script>/p' ./docs-final/index.html | \
        grep -v 'type="application/json"' | \
        sed '1d;$d' > /tmp/final-js-test.js
    
    if node --check /tmp/final-js-test.js 2>&1; then
        echo "✅ ✅ ✅ SUCCESS! JavaScript syntax is VALID!"
        echo ""
        echo "🎉 The fix is working perfectly!"
        echo ""
        echo "You can view the documentation at:"
        echo "  file://$(pwd)/docs-final/index.html"
        echo ""
        echo "Open it in a browser to confirm everything renders correctly."
    else
        echo "❌ JavaScript syntax error"
        head -30 /tmp/final-js-test.js
        exit 1
    fi
else
    echo "⚠️  Node.js not available"
    echo "Please open in browser: file://$(pwd)/docs-final/index.html"
fi
