#!/usr/bin/env bash
# Setup script for leaf.sh tests
# Makes leaf.sh executable and verifies test environment

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LEAF_SH_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
LEAF_SH="$LEAF_SH_ROOT/leaf.sh"

echo "Setting up leaf.sh test environment..."
echo ""

# Make leaf.sh executable
if [[ -f "$LEAF_SH" ]]; then
    chmod +x "$LEAF_SH"
    echo "✓ Made leaf.sh executable"
else
    echo "✗ ERROR: leaf.sh not found at: $LEAF_SH"
    exit 1
fi

# Check for dependencies
echo ""
echo "Checking dependencies..."

check_dep() {
    if command -v "$1" &>/dev/null; then
        echo "✓ $1 found"
        return 0
    else
        echo "✗ $1 not found"
        return 1
    fi
}

missing_deps=0

check_dep "yq" || missing_deps=1
check_dep "jq" || missing_deps=1
check_dep "bash" || missing_deps=1

# Check for myst.sh
if [[ -x "${LEAF_SH_ROOT}/.arty/bin/myst" ]]; then
    echo "✓ myst.sh found (via arty)"
elif [[ -x "${LEAF_SH_ROOT}/../myst.sh/myst.sh" ]]; then
    echo "✓ myst.sh found (sibling directory)"
elif command -v myst &>/dev/null; then
    echo "✓ myst.sh found (in PATH)"
else
    echo "✗ myst.sh not found"
    echo "  Run 'arty deps' in leaf.sh directory to install"
    missing_deps=1
fi

# Check for judge.sh
if [[ -x "${LEAF_SH_ROOT}/.arty/libs/judge.sh/judge.sh" ]]; then
    echo "✓ judge.sh found (via arty)"
elif [[ -x "${LEAF_SH_ROOT}/../judge.sh/judge.sh" ]]; then
    echo "✓ judge.sh found (sibling directory)"
elif command -v judge &>/dev/null; then
    echo "✓ judge.sh found (in PATH)"
else
    echo "⚠ judge.sh not found (needed to run tests)"
    echo "  Run 'arty deps' in leaf.sh directory to install"
fi

echo ""

if [[ $missing_deps -eq 0 ]]; then
    echo "✓ All dependencies satisfied!"
    echo ""
    echo "You can now run tests with:"
    echo "  ./run-tests.sh"
    echo ""
    exit 0
else
    echo "✗ Some dependencies are missing"
    echo ""
    echo "Install missing dependencies:"
    echo "  - yq: https://github.com/mikefarah/yq#install"
    echo "  - jq: sudo apt-get install jq  (or brew install jq)"
    echo "  - myst.sh: cd $LEAF_SH_ROOT && arty deps"
    echo ""
    exit 1
fi
