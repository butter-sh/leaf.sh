#!/usr/bin/env bash
# Test the fixed leaf.sh to ensure JavaScript escaping works correctly

set -e

echo "Testing leaf.sh JavaScript escaping fix..."
echo ""

# Create a test directory
TEST_DIR="/tmp/leaf-test-$$"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

# Create a test README with problematic characters
cat > README.md << 'EOF'
# Test Project

This README contains backticks in code blocks:

```bash
echo "Hello World"
`echo "nested backticks"`
```

And inline code with backticks: `echo test`

More backticks: \`escaped backticks\`

Special characters: {{mustache}} and $variables

```javascript
const template = `This is a template literal with ${variable}`;
```
EOF

# Create a minimal arty.yml
cat > arty.yml << 'EOF'
name: "test-project"
version: "1.0.0"
description: "Test project for debugging"
EOF

# Create a simple icon
cat > icon.svg << 'EOF'
<svg viewBox="0 0 24 24" fill="currentColor"><circle cx="12" cy="12" r="10"/></svg>
EOF

# Run the fixed leaf.sh
echo "Running fixed leaf.sh..."
bash ~/Projects/butter.sh/projects/leaf.sh/leaf-fixed.sh . -o ./docs 2>&1

# Check if the HTML was generated
if [ ! -f "./docs/index.html" ]; then
    echo "❌ ERROR: index.html was not generated!"
    exit 1
fi

echo ""
echo "✅ index.html generated successfully"
echo ""

# Check the JavaScript section for syntax errors
echo "Checking JavaScript syntax in generated HTML..."
echo ""

# Extract the script section and test it with Node.js if available
if command -v node >/dev/null 2>&1; then
    # Extract just the JavaScript from the script tag
    sed -n '/<script>/,/<\/script>/p' ./docs/index.html | sed '1d;$d' > test-script.js
    
    echo "Extracted JavaScript:"
    head -20 test-script.js
    echo ""
    
    # Try to parse it with Node.js
    if node --check test-script.js 2>&1; then
        echo "✅ JavaScript syntax is valid!"
    else
        echo "❌ JavaScript syntax error detected!"
        echo ""
        echo "First 50 lines of generated script:"
        head -50 test-script.js
        exit 1
    fi
else
    echo "⚠️  Node.js not available, skipping JavaScript validation"
    echo "   Manual check: Look for the readmeContent assignment around line 105"
    grep -n "const readmeContent" ./docs/index.html || true
fi

echo ""
echo "✅ All tests passed!"
echo "Generated file: ${TEST_DIR}/docs/index.html"
echo ""
echo "To view: open ${TEST_DIR}/docs/index.html"

# Cleanup
# rm -rf "$TEST_DIR"
