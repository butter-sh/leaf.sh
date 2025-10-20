#!/usr/bin/env bash

cd "$(dirname "$0")"

echo "=== Testing myst.sh directly with a simple conditional ==="
echo ""

# Create simple test
cat > /tmp/test-cond.myst << 'EOF'
<html>
<body>
<p>Before</p>
{{#if myst_enabled}}
<p>Myst is enabled!</p>
{{/if}}
<p>After</p>
</body>
</html>
EOF

cat > /tmp/test-cond.json << 'EOF'
{
  "myst_enabled": "true"
}
EOF

echo "Template:"
cat /tmp/test-cond.myst
echo ""

echo "Data:"
cat /tmp/test-cond.json
echo ""

echo "Running myst.sh:"
bash .arty/bin/myst -j /tmp/test-cond.json -o /tmp/test-cond-output.html /tmp/test-cond.myst
exit_code=$?

echo ""
echo "Exit code: $exit_code"
echo ""

if [ -f /tmp/test-cond-output.html ]; then
    echo "Output:"
    cat /tmp/test-cond-output.html
    echo ""
    
    if grep -q "{{#if" /tmp/test-cond-output.html; then
        echo "❌ PROBLEM: Myst didn't process conditionals!"
    else
        echo "✅ Myst processed conditionals correctly"
    fi
else
    echo "❌ No output file created"
fi
