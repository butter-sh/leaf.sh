#!/usr/bin/env bash
# test-leaf-debug.sh - Debug version with verbose output

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

echo "🧪 Testing leaf.sh with DEBUG output..."
echo ""

# Test 1: Help
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Test 1: Checking help output..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
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
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Test 2: Generating docs for whip.sh..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [[ ! -d "../whip.sh" ]]; then
    echo "⚠️  ../whip.sh not found"
    echo "   Checking if whip.sh exists elsewhere..."
    
    if [[ -d "../../whip.sh" ]]; then
        echo "   Found at ../../whip.sh"
        WHIP_DIR="../../whip.sh"
    else
        echo "   Skipping whip.sh test"
        WHIP_DIR=""
    fi
else
    WHIP_DIR="../whip.sh"
fi

if [[ -n "$WHIP_DIR" ]]; then
    echo "   Using whip.sh from: $WHIP_DIR"
    rm -rf ./test-whip-docs
    
    echo "   Running: ./leaf.sh $WHIP_DIR -o ./test-whip-docs --debug"
    
    if ./leaf.sh "$WHIP_DIR" -o ./test-whip-docs --debug 2>&1 | tee /tmp/leaf-debug.log; then
        echo ""
        if [[ -f "./test-whip-docs/index.html" ]]; then
            echo "✅ Documentation generated successfully"
            echo "   Output: ./test-whip-docs/index.html"
            echo "   Size: $(du -h ./test-whip-docs/index.html | cut -f1)"
            
            # Check HTML validity
            if grep -q "<html" "./test-whip-docs/index.html" && \
               grep -q "whip.sh" "./test-whip-docs/index.html"; then
                echo "✅ HTML appears valid"
                
                # Check for proper escaping
                if grep -q "&lt;" "./test-whip-docs/index.html"; then
                    echo "✅ HTML escaping is working"
                else
                    echo "⚠️  No escaped HTML found (might be okay if no special chars)"
                fi
            else
                echo "⚠️  HTML may have issues"
                echo "   First 20 lines:"
                head -20 ./test-whip-docs/index.html
            fi
        else
            echo "❌ Documentation generation failed"
            echo "   Debug log:"
            cat /tmp/leaf-debug.log
            exit 1
        fi
    else
        echo "❌ leaf.sh command failed"
        echo "   Debug log:"
        cat /tmp/leaf-debug.log
        exit 1
    fi
else
    echo "⚠️  Skipping whip.sh documentation test (directory not found)"
fi
echo ""

# Test 3: Generate landing page
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Test 3: Generating landing page..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

rm -rf ./test-landing

echo "   Running: ./leaf.sh --landing --projects-file ./templates/examples/projects.json -o ./test-landing --debug"

if ./leaf.sh --landing \
  --projects-file ./templates/examples/projects.json \
  --logo ./icon.svg \
  -o ./test-landing \
  --debug 2>&1 | tee /tmp/leaf-landing-debug.log; then
    echo ""
    if [[ -f "./test-landing/index.html" ]]; then
        echo "✅ Landing page generated successfully"
        echo "   Output: ./test-landing/index.html"
        echo "   Size: $(du -h ./test-landing/index.html | cut -f1)"
        
        # Check if HTML contains projects
        if grep -q "butter.sh" "./test-landing/index.html"; then
            echo "✅ Landing page content appears valid"
        else
            echo "⚠️  Landing page may have issues"
            echo "   First 20 lines:"
            head -20 ./test-landing/index.html
        fi
    else
        echo "❌ Landing page generation failed"
        echo "   Debug log:"
        cat /tmp/leaf-landing-debug.log
        exit 1
    fi
else
    echo "❌ leaf.sh command failed"
    echo "   Debug log:"
    cat /tmp/leaf-landing-debug.log
    exit 1
fi
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎉 All tests passed!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Generated files:"
if [[ -d "./test-whip-docs" ]]; then
    echo "  📄 ./test-whip-docs/index.html ($(du -h ./test-whip-docs/index.html | cut -f1))"
fi
if [[ -d "./test-landing" ]]; then
    echo "  📄 ./test-landing/index.html ($(du -h ./test-landing/index.html | cut -f1))"
fi
echo ""
echo "To view:"
if [[ -d "./test-whip-docs" ]]; then
    echo "  open ./test-whip-docs/index.html"
fi
if [[ -d "./test-landing" ]]; then
    echo "  open ./test-landing/index.html"
fi
echo ""
echo "Debug logs saved:"
echo "  /tmp/leaf-help.txt"
if [[ -f "/tmp/leaf-debug.log" ]]; then
    echo "  /tmp/leaf-debug.log"
fi
if [[ -f "/tmp/leaf-landing-debug.log" ]]; then
    echo "  /tmp/leaf-landing-debug.log"
fi
