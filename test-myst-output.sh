#!/usr/bin/env bash

cd "$(dirname "$0")"

echo "=== Testing myst.sh directly with the escaped content ==="
echo ""

# Use the actual JSON file that was generated
json_file="/tmp/working-test/debug-data.json"

if [ ! -f "$json_file" ]; then
    echo "Generating first..."
    bash leaf.sh ../whip.sh -o /tmp/working-test 2>&1 > /dev/null
fi

# Create a simple test template
cat > /tmp/test-myst-readme.myst << 'EOF'
<html><body>
<script>
const content = `{{{readme_content}}}`;
console.log("Content length:", content.length);
console.log("First 100 chars:", content.substring(0, 100));
</script>
</body></html>
EOF

# Run myst
echo "Running myst.sh..."
bash .arty/bin/myst -j "$json_file" -o /tmp/test-myst-output.html /tmp/test-myst-readme.myst

echo ""
if [ -f /tmp/test-myst-output.html ]; then
    echo "Myst output file created"
    echo "Size: $(wc -c < /tmp/test-myst-output.html) bytes"
    echo ""
    echo "Content of script section:"
    grep -A10 "const content" /tmp/test-myst-output.html | head -15
else
    echo "No output file"
fi
