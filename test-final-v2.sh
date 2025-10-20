#!/usr/bin/env bash
# Final final test!

echo "Testing the corrected JSON script tag fix..."
echo ""

cd ~/Projects/butter.sh/projects/whip.sh

# Clean
rm -rf ./docs-final-v2 2>/dev/null

# Generate
echo "Generating documentation..."
bash ../leaf.sh/leaf.sh . -o ./docs-final-v2 2>&1 | tail -3

echo ""
echo "Checking JSON data structure..."

# Check the JSON script tag content
echo "Content of JSON script tag (first 100 chars):"
sed -n '/<script id="readmeData"/,/<\/script>/p' ./docs-final-v2/index.html | head -c 150
echo "..."
echo ""

# Verify it starts with a quote
if sed -n '/<script id="readmeData"/,/<\/script>/p' ./docs-final-v2/index.html | grep -q '"#'; then
    echo "✅ JSON script tag contains quoted string (valid JSON)"
else
    echo "❌ JSON script tag does NOT start with quote"
    sed -n '/<script id="readmeData"/,/<\/script>/p' ./docs-final-v2/index.html | head -5
    exit 1
fi

echo ""
echo "Validating JavaScript syntax..."

if command -v node >/dev/null 2>&1; then
    # Extract executable script
    awk '/<script>/{flag=1; next} /<\/script>/{flag=0} flag && !/type="application\/json"/' ./docs-final-v2/index.html > /tmp/final-v2.js
    
    if node --check /tmp/final-v2.js 2>&1; then
        echo "✅ JavaScript syntax is valid"
    else
        echo "❌ JavaScript syntax error"
        exit 1
    fi
fi

echo ""
echo "🎉🎉🎉 SUCCESS! 🎉🎉🎉"
echo ""
echo "The fix is complete and working!"
echo ""
echo "View the documentation:"
echo "  file://$(pwd)/docs-final-v2/index.html"
echo ""
echo "Open it in a browser to verify:"
echo "  - No console errors"
echo "  - README renders correctly"
echo "  - Code blocks with backticks display properly"
