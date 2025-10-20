#!/usr/bin/env bash
# verify.sh - Verify the leaf.sh installation

set -euo pipefail

echo "🔍 Verifying leaf.sh installation..."
echo

# Check if we're in the right directory
if [[ ! -f "leaf.sh" ]]; then
    echo "❌ Error: leaf.sh not found in current directory"
    echo "   Please run this script from the leaf.sh project directory"
    exit 1
fi

echo "✅ Found leaf.sh script"

# Check dependencies
echo
echo "Checking dependencies..."
echo

missing=0

if command -v yq &>/dev/null; then
    echo "✅ yq found: $(yq --version 2>&1 | head -n1)"
else
    echo "❌ yq not found - Install from https://github.com/mikefarah/yq#install"
    missing=1
fi

if command -v jq &>/dev/null; then
    echo "✅ jq found: $(jq --version 2>&1)"
else
    echo "❌ jq not found - Install from https://stedolan.github.io/jq/download/"
    missing=1
fi

if command -v myst &>/dev/null || [[ -x ".arty/bin/myst" ]]; then
    echo "✅ myst.sh found"
else
    echo "⚠️  myst.sh not found - Run 'arty deps' to install"
    echo "   (Can be installed later if using arty.sh)"
fi

echo

# Check file structure
echo "Checking file structure..."
echo

files=(
    "arty.yml"
    "leaf.sh"
    "README.md"
    "LICENSE"
    "icon.svg"
    "templates/docs.html.myst"
    "templates/landing.html.myst"
    "templates/partials/_head.myst"
    "templates/partials/_header.myst"
    "templates/partials/_footer.myst"
    "templates/partials/_carbon_styles.myst"
    "templates/partials/_common_scripts.myst"
    "examples/generate-docs.sh"
    "examples/generate-landing.sh"
)

for file in "${files[@]}"; do
    if [[ -f "$file" ]]; then
        echo "✅ $file"
    else
        echo "❌ Missing: $file"
        missing=1
    fi
done

echo

# Check if leaf.sh is executable
if [[ -x "leaf.sh" ]]; then
    echo "✅ leaf.sh is executable"
else
    echo "⚠️  leaf.sh is not executable - Run: chmod +x leaf.sh"
fi

echo

# Summary
if [[ $missing -eq 0 ]]; then
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🎉 Verification complete - All checks passed!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo
    echo "Next steps:"
    echo "  1. Make executable: chmod +x leaf.sh"
    echo "  2. View help: ./leaf.sh --help"
    echo "  3. Generate docs: ./leaf.sh . -o ./docs"
    echo
else
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "⚠️  Verification found some issues"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo
    echo "Please install missing dependencies before using leaf.sh"
    echo
fi
