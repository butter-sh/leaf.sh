#!/usr/bin/env bash
# debug-myst.sh - Debug myst.sh template processing

cd "$(dirname "${BASH_SOURCE[0]}")"

echo "🔍 Debugging myst.sh template processing..."
echo ""

# Create a simple test template
cat > /tmp/test-template.myst << 'EOF'
<html>
<head><title>{{title}}</title></head>
<body>
<h1>{{heading}}</h1>
<p>{{content}}</p>
{{#if show_extra}}
<p>Extra content!</p>
{{/if}}
</body>
</html>
EOF

# Create test data
cat > /tmp/test-data.json << 'EOF'
{
  "title": "Test Page",
  "heading": "Hello World",
  "content": "This is a test",
  "show_extra": "true"
}
EOF

echo "1. Test template:"
cat /tmp/test-template.myst
echo ""

echo "2. Test data:"
cat /tmp/test-data.json
echo ""

echo "3. Running myst.sh..."
if bash .arty/bin/myst -j /tmp/test-data.json -o /tmp/test-output.html /tmp/test-template.myst 2>&1; then
    echo "✅ Myst succeeded"
    echo ""
    echo "4. Output:"
    cat /tmp/test-output.html
    echo ""
    
    # Check if variables were replaced
    if grep -q "{{" /tmp/test-output.html; then
        echo "❌ Variables not replaced! myst.sh is not working correctly"
        exit 1
    else
        echo "✅ Variables were replaced correctly"
    fi
else
    echo "❌ Myst failed"
    exit 1
fi

echo ""
echo "5. Now testing with actual leaf.sh data..."
echo ""

# Try generating with debug
DEBUG=1 bash leaf.sh ../whip.sh -o /tmp/leaf-test-debug 2>&1 | head -50
