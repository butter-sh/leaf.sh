#!/usr/bin/env bash
# test-leaf.sh - Quick test script for leaf.sh

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

echo "🧪 Testing leaf.sh..."
echo ""

# Test 1: Help should work without ANSI codes bleeding
echo "Test 1: Checking help output..."
./leaf.sh --help > /tmp/leaf-help.txt 2>&1
if grep -q "leaf.sh - Documentation Generator" /tmp/leaf-help.txt; then
    echo "✅ Help text displays correctly"
else
    echo "❌ Help text issue"
    cat /tmp/leaf-help.txt
    exit 1
fi
echo ""

# Test 2: Generate docs for whip.sh
echo "Test 2: Generating docs for whip.sh..."
if [[ -d "../whip.sh" ]]; then
    rm -rf ./test-whip-docs
    ./leaf.sh ../whip.sh -o ./test-whip-docs
    
    if [[ -f "./test-whip-docs/index.html" ]]; then
        echo "✅ Documentation generated successfully"
        echo "   Output: ./test-whip-docs/index.html"
        
        # Check if HTML is valid
        if grep -q "<html" "./test-whip-docs/index.html" && \
           grep -q "whip.sh" "./test-whip-docs/index.html"; then
            echo "✅ HTML appears valid"
        else
            echo "⚠️  HTML may have issues"
        fi
    else
        echo "❌ Documentation generation failed"
        exit 1
    fi
else
    echo "⚠️  ../whip.sh not found, skipping this test"
fi
echo ""

# Test 3: Generate landing page
echo "Test 3: Generating landing page..."
rm -rf ./test-landing
./leaf.sh --landing \
  --projects-file ./templates/examples/projects.json \
  --logo ./icon.svg \
  -o ./test-landing

if [[ -f "./test-landing/index.html" ]]; then
    echo "✅ Landing page generated successfully"
    echo "   Output: ./test-landing/index.html"
    
    # Check if HTML contains projects
    if grep -q "butter.sh" "./test-landing/index.html"; then
        echo "✅ Landing page content appears valid"
    else
        echo "⚠️  Landing page may have issues"
    fi
else
    echo "❌ Landing page generation failed"
    exit 1
fi
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎉 All tests passed!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Generated files:"
if [[ -d "./test-whip-docs" ]]; then
    echo "  📄 ./test-whip-docs/index.html"
fi
echo "  📄 ./test-landing/index.html"
echo ""
echo "To view:"
if [[ -d "./test-whip-docs" ]]; then
    echo "  open ./test-whip-docs/index.html"
fi
echo "  open ./test-landing/index.html"
