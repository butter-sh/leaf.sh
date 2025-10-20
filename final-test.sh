#!/usr/bin/env bash
# Final test of the complete fix

echo "Testing the complete fix..."
echo ""

cd ~/Projects/butter.sh/projects/whip.sh

# Clean any previous output
rm -rf ./docs-test 2>/dev/null

# Generate docs
echo "Generating documentation..."
bash ../leaf.sh/leaf.sh . -o ./docs-test 2>&1 | tail -5

echo ""
echo "Checking the generated JavaScript..."

# Extract the specific line
READMELINE=$(grep -n "const readmeContent" ./docs-test/index.html | head -1)
echo "Line with readmeContent: $READMELINE"
echo ""

# Show it
echo "Content of that line:"
LINE_NUM=$(echo "$READMELINE" | cut -d: -f1)
sed -n "${LINE_NUM}p" ./docs-test/index.html | head -c 200
echo "..."
echo ""

# Validate with Node.js
if command -v node >/dev/null 2>&1; then
    echo "Running Node.js syntax validation..."
    sed -n '/<script>/,/<\/script>/p' ./docs-test/index.html | sed '1d;$d' > /tmp/final-test.js
    
    if node --check /tmp/final-test.js 2>&1; then
        echo "✅ SUCCESS! JavaScript syntax is valid!"
        echo ""
        echo "The fix is working correctly."
        echo ""
        echo "You can view the documentation at:"
        echo "  file://$(pwd)/docs-test/index.html"
    else
        echo "❌ Still has syntax errors"
        echo ""
        echo "First 30 lines of JavaScript:"
        head -30 /tmp/final-test.js
        exit 1
    fi
else
    echo "⚠️  Node.js not available for validation"
    echo "Please open the file in a browser and check console"
fi
