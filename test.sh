#!/usr/bin/env bash

# leaf.sh Testing Checklist
# Run this script to test all major features

set -e

echo "╔═══════════════════════════════════════════╗"
echo "║                                           ║"
echo "║   🌿 leaf.sh v2.0 Test Suite 🌿          ║"
echo "║                                           ║"
echo "╚═══════════════════════════════════════════╝"
echo

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_TOTAL=0

# Test function
test_feature() {
    local name="$1"
    local command="$2"
    local check="$3"
    
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    echo -e "${BLUE}Test $TESTS_TOTAL:${NC} $name"
    
    # Run command
    if eval "$command" > /dev/null 2>&1; then
        # Check result
        if eval "$check" > /dev/null 2>&1; then
            echo -e "${GREEN}✓ PASSED${NC}"
            TESTS_PASSED=$((TESTS_PASSED + 1))
        else
            echo -e "${RED}✗ FAILED${NC} (check failed)"
            TESTS_FAILED=$((TESTS_FAILED + 1))
        fi
    else
        echo -e "${RED}✗ FAILED${NC} (command failed)"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
    echo
}

# Create test environment
echo "Setting up test environment..."
TEST_DIR="/tmp/leaf-test-$$"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

# Create sample arty.sh project
mkdir -p sample-project/{examples,_assets/icon}
cat > sample-project/arty.yml << 'EOF'
name: "test-project"
version: "1.0.0"
description: "Test project for leaf.sh"
author: "Test Author"
license: "MIT"
main: "main.sh"
EOF

cat > sample-project/README.md << 'EOF'
# Test Project

This is a test project for leaf.sh documentation generator.

## Features

- Feature 1
- Feature 2
- Feature 3
EOF

cat > sample-project/main.sh << 'EOF'
#!/usr/bin/env bash
echo "Hello from main.sh"
EOF

cat > sample-project/examples/usage.sh << 'EOF'
#!/usr/bin/env bash
# Example usage
./main.sh
EOF

cat > sample-project/_assets/icon/icon.svg << 'EOF'
<svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" viewBox="0 0 24 24">
  <circle cx="12" cy="12" r="10" fill="#86efac"/>
</svg>
EOF

# Copy leaf.sh to test directory
cp /home/valknar/Projects/hammer.sh/templates/leaf/leaf.sh ./leaf.sh
chmod +x ./leaf.sh

echo -e "${GREEN}✓ Test environment ready${NC}"
echo

# Run tests
echo "═══════════════════════════════════════════"
echo "DOCUMENTATION MODE TESTS"
echo "═══════════════════════════════════════════"
echo

test_feature \
    "Basic documentation generation" \
    "./leaf.sh sample-project" \
    "test -f sample-project/docs/index.html"

test_feature \
    "Help flag works" \
    "./leaf.sh --help" \
    "true"

test_feature \
    "Custom output directory" \
    "./leaf.sh sample-project -o sample-project/custom-docs" \
    "test -f sample-project/custom-docs/index.html"

test_feature \
    "Base path configuration" \
    "./leaf.sh sample-project --base-path /test/ -o sample-project/basepath-docs" \
    "grep -q 'base href=\"/test/\"' sample-project/basepath-docs/index.html"

test_feature \
    "GitHub URL configuration" \
    "./leaf.sh sample-project --github https://github.com/test -o sample-project/github-docs" \
    "grep -q 'github.com/test' sample-project/github-docs/index.html"

echo "═══════════════════════════════════════════"
echo "LANDING PAGE MODE TESTS"
echo "═══════════════════════════════════════════"
echo

test_feature \
    "Basic landing page generation" \
    "./leaf.sh --landing -o landing-basic" \
    "test -f landing-basic/index.html"

test_feature \
    "Landing page with custom GitHub" \
    "./leaf.sh --landing --github https://github.com/custom -o landing-github" \
    "grep -q 'github.com/custom' landing-github/index.html"

test_feature \
    "Landing page with custom projects" \
    "./leaf.sh --landing --projects '[{\"url\":\"https://test.com\",\"label\":\"Test\",\"desc\":\"Test project\",\"class\":\"card-project\"}]' -o landing-projects" \
    "grep -q 'test.com' landing-projects/index.html"

test_feature \
    "Landing page base path" \
    "./leaf.sh --landing --base-path /landing/ -o landing-basepath" \
    "grep -q 'base href=\"/landing/\"' landing-basepath/index.html"

echo "═══════════════════════════════════════════"
echo "HTML VALIDATION TESTS"
echo "═══════════════════════════════════════════"
echo

test_feature \
    "Documentation HTML structure" \
    "true" \
    "grep -q '<!DOCTYPE html>' sample-project/docs/index.html && grep -q '</html>' sample-project/docs/index.html"

test_feature \
    "Landing page HTML structure" \
    "true" \
    "grep -q '<!DOCTYPE html>' landing-basic/index.html && grep -q '</html>' landing-basic/index.html"

test_feature \
    "Documentation has theme toggle" \
    "true" \
    "grep -q 'themeToggle' sample-project/docs/index.html"

test_feature \
    "Landing has theme toggle" \
    "true" \
    "grep -q 'themeToggle' landing-basic/index.html"

test_feature \
    "Documentation includes Tailwind CSS" \
    "true" \
    "grep -q 'tailwindcss.com' sample-project/docs/index.html"

test_feature \
    "Landing includes Tailwind CSS" \
    "true" \
    "grep -q 'tailwindcss.com' landing-basic/index.html"

test_feature \
    "Documentation includes Highlight.js" \
    "true" \
    "grep -q 'highlight.min.js' sample-project/docs/index.html"

test_feature \
    "Documentation includes project name" \
    "true" \
    "grep -q 'test-project' sample-project/docs/index.html"

test_feature \
    "Documentation includes README content" \
    "true" \
    "grep -q 'Test Project' sample-project/docs/index.html"

test_feature \
    "Documentation includes source files" \
    "true" \
    "grep -q 'main.sh' sample-project/docs/index.html"

test_feature \
    "Documentation includes examples" \
    "true" \
    "grep -q 'usage.sh' sample-project/docs/index.html"

echo "═══════════════════════════════════════════"
echo "THEME TESTS"
echo "═══════════════════════════════════════════"
echo

test_feature \
    "Documentation has dark mode styles" \
    "true" \
    "grep -q 'dark:' sample-project/docs/index.html"

test_feature \
    "Landing has carbon theme" \
    "true" \
    "grep -q 'carbon-light' landing-basic/index.html"

test_feature \
    "Landing has primary color" \
    "true" \
    "grep -q '#86efac' landing-basic/index.html"

echo "═══════════════════════════════════════════"
echo "ERROR HANDLING TESTS"
echo "═══════════════════════════════════════════"
echo

test_feature \
    "Handles non-existent project directory" \
    "./leaf.sh /nonexistent 2>&1 | grep -q 'not found'" \
    "true"

test_feature \
    "Shows help with --help" \
    "./leaf.sh --help | grep -q 'USAGE'" \
    "true"

# Summary
echo "═══════════════════════════════════════════"
echo "TEST SUMMARY"
echo "═══════════════════════════════════════════"
echo
echo "Total Tests: $TESTS_TOTAL"
echo -e "Passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Failed: ${RED}$TESTS_FAILED${NC}"
echo

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}╔═══════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                           ║${NC}"
    echo -e "${GREEN}║       ✓ ALL TESTS PASSED! 🎉             ║${NC}"
    echo -e "${GREEN}║                                           ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════╝${NC}"
    echo
    echo "Generated files available for inspection:"
    echo "  - Documentation: $TEST_DIR/sample-project/docs/index.html"
    echo "  - Landing Page: $TEST_DIR/landing-basic/index.html"
    echo
    echo "Open in browser:"
    echo "  open $TEST_DIR/sample-project/docs/index.html"
    echo "  open $TEST_DIR/landing-basic/index.html"
else
    echo -e "${RED}╔═══════════════════════════════════════════╗${NC}"
    echo -e "${RED}║                                           ║${NC}"
    echo -e "${RED}║       ✗ SOME TESTS FAILED                ║${NC}"
    echo -e "${RED}║                                           ║${NC}"
    echo -e "${RED}╚═══════════════════════════════════════════╝${NC}"
    echo
    echo "Check test directory for details:"
    echo "  cd $TEST_DIR"
fi

echo
echo "Test directory: $TEST_DIR"
echo "To cleanup: rm -rf $TEST_DIR"
echo

# Exit with appropriate code
exit $TESTS_FAILED
