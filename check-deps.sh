#!/usr/bin/env bash
# check-deps.sh - Check if all dependencies are available

set -euo pipefail

echo "🔍 Checking leaf.sh dependencies..."
echo ""

all_good=true

# Check yq
echo -n "Checking yq... "
if command -v yq &>/dev/null; then
    echo "✅ $(yq --version 2>&1 | head -n1)"
else
    echo "❌ NOT FOUND"
    echo "   Install: https://github.com/mikefarah/yq#install"
    all_good=false
fi

# Check jq
echo -n "Checking jq... "
if command -v jq &>/dev/null; then
    echo "✅ $(jq --version 2>&1)"
else
    echo "❌ NOT FOUND"
    echo "   Install: https://stedolan.github.io/jq/download/"
    all_good=false
fi

# Check myst.sh
echo -n "Checking myst.sh... "
if command -v myst &>/dev/null; then
    echo "✅ Found in PATH"
elif [[ -x ".arty/bin/myst" ]]; then
    echo "✅ Found at .arty/bin/myst"
elif [[ -x "../myst.sh/myst.sh" ]]; then
    echo "✅ Found at ../myst.sh/myst.sh"
else
    echo "❌ NOT FOUND"
    echo "   Install: Run 'arty deps' in leaf.sh directory"
    echo "   Or: Install myst.sh from https://github.com/butter-sh/myst.sh"
    all_good=false
fi

# Check bash
echo -n "Checking bash... "
echo "✅ $BASH_VERSION"

echo ""

if $all_good; then
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✅ All dependencies are available!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "You can now run:"
    echo "  ./leaf.sh --help"
    echo "  ./test-leaf.sh"
else
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "❌ Some dependencies are missing"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Please install missing dependencies before using leaf.sh"
    exit 1
fi
