#!/usr/bin/env bash
# test-simple-gen.sh - Simple generation test with full output

cd "$(dirname "${BASH_SOURCE[0]}")"

echo "Testing simple documentation generation..."
echo ""

# Enable debug mode
export DEBUG=1

# Run leaf.sh and capture all output
echo "Running: bash leaf.sh ../whip.sh -o /tmp/simple-test"
echo ""

bash leaf.sh ../whip.sh -o /tmp/simple-test 2>&1

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Checking output..."
echo ""

if [[ -f "/tmp/simple-test/index.html" ]]; then
    echo "✅ HTML file created"
    echo "   Size: $(wc -c < /tmp/simple-test/index.html) bytes"
    echo ""
    
    # Check for unprocessed variables
    if grep -q "{{" /tmp/simple-test/index.html; then
        echo "❌ Found unprocessed myst variables:"
        grep -o "{{[^}]*}}" /tmp/simple-test/index.html | head -5
        echo ""
    else
        echo "✅ No unprocessed myst variables"
    fi
    
    # Check for empty code blocks
    if grep -q '<code class="language-bash"></code>' /tmp/simple-test/index.html; then
        echo "❌ Found empty code blocks"
        echo ""
    else
        echo "✅ Code blocks have content"
    fi
    
    # Check what JSON was created
    echo ""
    echo "Looking for JSON data file..."
    ls -lah /tmp/leaf_docs_*.json 2>/dev/null | tail -1
    
    if ls /tmp/leaf_docs_*.json 2>/dev/null | tail -1 | read jsonfile; then
        echo "Latest JSON file:"
        cat "$jsonfile" | jq . | head -20
    fi
else
    echo "❌ HTML file not created"
fi
