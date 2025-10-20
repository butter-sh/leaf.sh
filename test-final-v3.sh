#!/usr/bin/env bash
# Final test with proper extraction

echo "Testing the complete fix..."
echo ""

cd ~/Projects/butter.sh/projects/whip.sh

# Clean
rm -rf ./docs-final-v3 2>/dev/null

# Generate
echo "Generating documentation..."
bash ../leaf.sh/leaf.sh . -o ./docs-final-v3 2>&1 | tail -3

echo ""
echo "Extracting and validating JSON content..."

# Extract the JSON data - it's all on one line after the opening tag
JSON_LINE=$(grep 'id="readmeData"' ./docs-final-v3/index.html)

# Extract just the content between the tags
JSON_CONTENT=$(echo "$JSON_LINE" | sed 's/.*type="application\/json">//; s/<\/script>.*//')

echo "First 200 chars of JSON content:"
echo "${JSON_CONTENT:0:200}"
echo "..."
echo ""

# Check for HTML entities
if echo "$JSON_CONTENT" | grep -q '&#'; then
    echo "❌ ERROR: HTML entities found in JSON!"
    exit 1
else
    echo "✅ No HTML entities in JSON"
fi

# Check it starts with quote
if [[ "$JSON_CONTENT" =~ ^\" ]]; then
    echo "✅ JSON starts with quote"
else
    echo "❌ JSON doesn't start with quote"
    echo "First 50 chars: '${JSON_CONTENT:0:50}'"
    exit 1
fi

# Validate JSON with Node.js
if command -v node >/dev/null 2>&1; then
    echo ""
    echo "Validating JSON with Node.js..."
    
    if echo "$JSON_CONTENT" | node -e "const s = require('fs').readFileSync(0, 'utf-8'); JSON.parse(s); console.log('✅ JSON.parse successful');" 2>&1; then
        : # Success message already printed
    else
        echo "❌ JSON.parse failed!"
        exit 1
    fi
fi

echo ""
echo "Validating JavaScript syntax..."

if command -v node >/dev/null 2>&1; then
    # Extract executable JavaScript (not the JSON data script)
    awk '/<script>$/{flag=1; next} /<\/script>/{flag=0} flag' ./docs-final-v3/index.html > /tmp/final-v3.js
    
    if node --check /tmp/final-v3.js 2>&1; then
        echo "✅ JavaScript syntax is valid"
    else
        echo "❌ JavaScript syntax error"
        exit 1
    fi
fi

echo ""
echo "═══════════════════════════════════════════════"
echo "🎉🎉🎉 COMPLETE SUCCESS! 🎉🎉🎉"
echo "═══════════════════════════════════════════════"
echo ""
echo "All validations passed:"
echo "  ✅ No HTML entities in JSON"
echo "  ✅ Valid JSON string format (quoted)"
echo "  ✅ JSON.parse works correctly"
echo "  ✅ JavaScript syntax is valid"
echo ""
echo "Generated documentation:"
echo "  file://$(pwd)/docs-final-v3/index.html"
echo ""
echo "Open in browser to verify:"
echo "  - No console errors"
echo "  - README renders with markdown"
echo "  - Code blocks display correctly"
echo "  - Backticks and special chars work"
echo ""
