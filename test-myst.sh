#!/usr/bin/env bash
# test-myst.sh - Test if myst.sh is working

cd "$(dirname "${BASH_SOURCE[0]}")"

echo "Testing myst.sh..."
echo ""

echo "1. Check if myst.sh symlink is valid:"
ls -la .arty/bin/myst

echo ""
echo "2. Check if target exists:"
target=$(readlink .arty/bin/myst)
if [[ -f "$target" ]]; then
    echo "✅ Target exists: $target"
    ls -la "$target"
else
    echo "❌ Target does not exist: $target"
    exit 1
fi

echo ""
echo "3. Try to execute myst:"
if bash .arty/bin/myst --help 2>&1 | head -5; then
    echo "✅ myst.sh is executable"
else
    echo "❌ myst.sh failed to execute"
    exit 1
fi

echo ""
echo "4. Test find_myst function:"
# Source the find_myst function from leaf.sh
source <(grep -A 20 "^find_myst()" leaf.sh | sed '/^}/q')

if myst_path=$(find_myst); then
    echo "✅ find_myst succeeded: $myst_path"
else
    echo "❌ find_myst failed"
    exit 1
fi

echo ""
echo "5. Try running leaf.sh with stderr visible:"
bash leaf.sh ../whip.sh -o ./test-myst-check 2>&1
