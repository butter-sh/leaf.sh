#!/usr/bin/env bash
# Generate docs for whip.sh and examine line 105

set -e

cd ~/Projects/butter.sh/projects/whip.sh

echo "Generating docs for whip.sh..."
bash ../leaf.sh/leaf.sh . -o /tmp/whip-docs --debug 2>&1 | tail -20

echo ""
echo "Checking line 105 of generated HTML..."
echo "========================================"
sed -n '105p' /tmp/whip-docs/index.html
echo ""
echo "Character 35 and surrounding context:"
sed -n '105p' /tmp/whip-docs/index.html | cut -c 30-45 | od -c
echo ""

echo "Lines 100-110:"
sed -n '100,110p' /tmp/whip-docs/index.html | cat -n

echo ""
echo "Full script section:"
sed -n '/<script>/,/<\/script>/p' /tmp/whip-docs/index.html | head -20

echo ""
echo "Checking for the readmeContent line specifically:"
grep -n "const readmeContent" /tmp/whip-docs/index.html || echo "Not found"

echo ""
echo "Checking with Node.js..."
if command -v node >/dev/null 2>&1; then
    sed -n '/<script>/,/<\/script>/p' /tmp/whip-docs/index.html | sed '1d;$d' > /tmp/test-whip.js
    node --check /tmp/test-whip.js || {
        echo "JavaScript error found! Here's the problematic section:"
        head -30 /tmp/test-whip.js
    }
fi
