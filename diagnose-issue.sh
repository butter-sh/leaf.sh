#!/usr/bin/env bash
# Quick diagnostic to understand the exact error

echo "Let's diagnose the issue step by step..."
echo ""

# Test 1: What does jq -Rs produce with backticks?
echo "Test 1: jq -Rs with backticks"
echo '---'
test_content='Code with `backticks` and more `here`'
result=$(printf '%s' "$test_content" | jq -Rs '.')
echo "Input: $test_content"
echo "Output from jq -Rs: $result"
echo "Length: ${#result}"
echo ""

# Test 2: What happens when we insert this into JavaScript?
echo "Test 2: Inserting into JavaScript"
echo '---'
cat > /tmp/test-js.html << EOF
<script>
const content = $result;
console.log(content);
</script>
EOF

echo "Generated HTML script tag:"
cat /tmp/test-js.html
echo ""

# Test 3: Can Node validate it?
if command -v node >/dev/null 2>&1; then
    echo "Test 3: Node.js validation"
    echo '---'
    sed -n '/<script>/,/<\/script>/p' /tmp/test-js.html | sed '1d;$d' > /tmp/test-script.js
    if node --check /tmp/test-script.js 2>&1; then
        echo "✅ Valid JavaScript"
    else
        echo "❌ Invalid JavaScript"
    fi
    echo ""
fi

# Test 4: What about triple-backtick code blocks?
echo "Test 4: Full markdown with code blocks"
echo '---'
markdown_test='# Title

```bash
echo "test"
`nested`
```

Inline `code` here.'

result2=$(printf '%s' "$markdown_test" | jq -Rs '.')
echo "Markdown input (escaped for display):"
echo "$markdown_test" | cat -v
echo ""
echo "After jq -Rs:"
echo "$result2"
echo ""

cat > /tmp/test-js2.html << EOF
<script>
const content = $result2;
console.log(content);
</script>
EOF

echo "Generated JavaScript:"
cat /tmp/test-js2.html
echo ""

if command -v node >/dev/null 2>&1; then
    sed -n '/<script>/,/<\/script>/p' /tmp/test-js2.html | sed '1d;$d' > /tmp/test-script2.js
    echo "Validation:"
    if node --check /tmp/test-script2.js 2>&1; then
        echo "✅ Valid JavaScript"
    else
        echo "❌ Invalid JavaScript - THIS IS THE PROBLEM!"
        echo ""
        echo "Raw script content:"
        cat /tmp/test-script2.js
    fi
fi

echo ""
echo "Summary: If test 4 fails, we need to fix how jq handles backticks"
