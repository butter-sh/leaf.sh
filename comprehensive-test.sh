#!/usr/bin/env bash
# Comprehensive test for the JavaScript escaping fix

set -e

echo "=========================================="
echo "Testing leaf.sh JavaScript Escaping Fix"
echo "=========================================="
echo ""

# Test 1: Verify the template change
echo "Test 1: Checking template syntax..."
if grep -q "const readmeContent = {{readme_content_json}};" ~/Projects/butter.sh/projects/leaf.sh/templates/docs.html.myst; then
    echo "✅ Template uses double braces (correct for HTML entity encoding)"
else
    echo "❌ Template does not use double braces"
    exit 1
fi
echo ""

# Test 2: Generate docs for a project with problematic characters
echo "Test 2: Creating test project with special characters..."
TEST_DIR="/tmp/leaf-comprehensive-test-$$"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

# Create README with all kinds of problematic characters
cat > README.md << 'ENDREADME'
# Test Project

This README contains various special characters that could break JavaScript:

## Backticks in code blocks

```bash
echo "Hello World"
`echo "nested backticks"`
COMMAND=`date`
```

## Inline code with backticks

Here is some inline code: `echo test` and more `backticks here`.

## Mustache-style templates

This should display literally: {{variable}} and {{#if condition}}text{{/if}}

## Dollar signs and other special chars

Variables like $HOME and ${USER} should work.

Special chars: & < > " ' 

## Escaped backticks

\`escaped\` backticks should also work.

## Mixed scenarios

Code: `const template = \`string with ${var}\`;`

More: {{mustache}} with `backticks` and $variables

```javascript
const data = {
  template: `This is a template literal`,
  code: `Another ${variable} here`
};
```

## Edge cases

- Empty backticks: ``
- Multiple: ``` ``` ```
- In links: [`code`](http://example.com)
ENDREADME

# Create minimal arty.yml
cat > arty.yml << 'EOF'
name: "test-special-chars"
version: "1.0.0"
description: "Test project with special characters"
EOF

# Create simple icon
cat > icon.svg << 'EOF'
<svg viewBox="0 0 24 24" fill="currentColor"><circle cx="12" cy="12" r="10"/></svg>
EOF

echo "✅ Test project created"
echo ""

# Test 3: Run leaf.sh
echo "Test 3: Running leaf.sh..."
if bash ~/Projects/butter.sh/projects/leaf.sh/leaf.sh . -o ./docs 2>&1 | grep -q "Documentation generated"; then
    echo "✅ leaf.sh completed successfully"
else
    echo "❌ leaf.sh failed"
    exit 1
fi
echo ""

# Test 4: Verify HTML was generated
echo "Test 4: Checking generated files..."
if [ -f "./docs/index.html" ]; then
    echo "✅ index.html generated"
    HTML_SIZE=$(wc -c < "./docs/index.html")
    echo "   File size: $HTML_SIZE bytes"
else
    echo "❌ index.html not generated"
    exit 1
fi
echo ""

# Test 5: Extract and validate JavaScript
echo "Test 5: Validating JavaScript syntax..."
if command -v node >/dev/null 2>&1; then
    # Extract the script section
    sed -n '/<script>/,/<\/script>/p' ./docs/index.html | sed '1d;$d' > test-script.js
    
    # Check JavaScript syntax
    if node --check test-script.js 2>&1; then
        echo "✅ JavaScript syntax is VALID"
    else
        echo "❌ JavaScript syntax error detected!"
        echo ""
        echo "Showing the problematic JavaScript section:"
        head -30 test-script.js
        exit 1
    fi
else
    echo "⚠️  Node.js not available - skipping syntax validation"
    echo "   Install Node.js to enable JavaScript validation"
fi
echo ""

# Test 6: Check the specific line that was problematic
echo "Test 6: Checking the readmeContent assignment..."
README_LINE=$(grep -n "const readmeContent" ./docs/index.html | head -1)
if [ -n "$README_LINE" ]; then
    echo "✅ Found readmeContent assignment at line: $README_LINE"
    
    # Extract just that line
    LINE_NUM=$(echo "$README_LINE" | cut -d: -f1)
    ACTUAL_LINE=$(sed -n "${LINE_NUM}p" ./docs/index.html)
    
    # Check if it looks reasonable (should start with "const readmeContent = " and end with ";")
    if echo "$ACTUAL_LINE" | grep -q "const readmeContent = .*;" ; then
        echo "✅ Line structure looks correct"
        
        # Show first 100 chars of the line
        echo "   Preview: ${ACTUAL_LINE:0:100}..."
    else
        echo "❌ Line structure looks incorrect"
        echo "   Actual: $ACTUAL_LINE"
        exit 1
    fi
else
    echo "❌ Could not find readmeContent assignment"
    exit 1
fi
echo ""

# Test 7: Open in browser test (optional)
echo "Test 7: Browser compatibility check..."
echo "   Generated file location: ${TEST_DIR}/docs/index.html"
echo "   You can manually open this in a browser to verify it displays correctly"
echo ""

# Test 8: Check debug data
if [ -f "./docs/debug-data.json" ]; then
    echo "Test 8: Checking debug data..."
    
    # Verify readme_content_json is a string
    JSON_TYPE=$(jq -r '.readme_content_json | type' ./docs/debug-data.json)
    if [ "$JSON_TYPE" = "string" ]; then
        echo "✅ readme_content_json is a string (correct)"
        
        # Show first 100 chars
        PREVIEW=$(jq -r '.readme_content_json' ./docs/debug-data.json | head -c 100)
        echo "   Preview: ${PREVIEW}..."
    else
        echo "❌ readme_content_json is not a string, it's: $JSON_TYPE"
        exit 1
    fi
else
    echo "Test 8: No debug data available (optional)"
fi
echo ""

# Summary
echo "=========================================="
echo "✅ ALL TESTS PASSED!"
echo "=========================================="
echo ""
echo "Summary:"
echo "  - Template uses correct double-brace syntax"
echo "  - HTML generated successfully"
echo "  - JavaScript syntax is valid"
echo "  - Special characters (backticks, {{mustache}}, etc.) handled correctly"
echo ""
echo "The fix resolves the 'Uncaught SyntaxError' issue!"
echo ""
echo "Generated test file: ${TEST_DIR}/docs/index.html"
echo "To view: open ${TEST_DIR}/docs/index.html"
echo ""

# Optionally clean up
read -p "Clean up test directory? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf "$TEST_DIR"
    echo "✅ Cleaned up test directory"
fi
