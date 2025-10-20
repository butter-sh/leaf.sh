#!/usr/bin/env bash

cd "$(dirname "$0")"

# Create a test project with template syntax in README
test_dir="/tmp/leaf-test-project-$$"
mkdir -p "$test_dir"

cat > "$test_dir/arty.yml" << 'EOF'
name: "test-project"
version: "1.0.0"
description: "Testing MyST escaping"
EOF

cat > "$test_dir/README.md" << 'EOF'
# Test Project

This README contains MyST template syntax that should be displayed literally:

- Author: {{author}}
- Version: {{version}}
- Status: {{status}}

These should appear as {{variable}} in the output, not disappear.
EOF

echo "🧪 Testing leaf.sh with MyST template syntax in README"
echo ""
echo "README content:"
cat "$test_dir/README.md"
echo ""
echo "=" | tr '=' '=' | head -c 60; echo ""
echo ""

# Generate docs
output_dir="/tmp/leaf-test-output-$$"
bash ./leaf.sh "$test_dir" -o "$output_dir" 2>&1 | grep -E "(ℹ|✓|✗)"

echo ""
echo "Checking generated HTML..."
if [ -f "$output_dir/index.html" ]; then
    # Check for unprocessed {{
    unprocessed=$(grep -o "{{" "$output_dir/index.html" | wc -l | tr -d ' ')
    
    # Check for HTML entities
    has_entities=$(grep -o "&#123;&#123;" "$output_dir/index.html" | wc -l | tr -d ' ')
    
    echo ""
    echo "Results:"
    echo "  Unprocessed '{{' found: $unprocessed"
    echo "  HTML entities '&#123;&#123;' found: $has_entities"
    echo ""
    
    if [ "$unprocessed" -eq "0" ] && [ "$has_entities" -gt "0" ]; then
        echo "✅ SUCCESS: MyST syntax properly escaped!"
        echo ""
        echo "Sample from output:"
        grep -A2 -B2 "&#123;&#123;author" "$output_dir/index.html" | head -10
    else
        echo "❌ FAILED: MyST syntax not properly handled"
        if [ "$unprocessed" -gt "0" ]; then
            echo ""
            echo "Unprocessed template syntax found at:"
            grep -n "{{" "$output_dir/index.html" | head -5
        fi
    fi
else
    echo "❌ FAILED: Output file not generated"
fi

# Cleanup
rm -rf "$test_dir" "$output_dir"
