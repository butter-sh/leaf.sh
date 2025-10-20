#!/usr/bin/env bash

cd "$(dirname "$0")"

echo "=== FULL PIPELINE TEST ==="
echo ""

# Step 1: Source the function
source ./leaf.sh 2>/dev/null

# Step 2: Get original README
readme_original=$(cat ../whip.sh/README.md | tail -5)
echo "Step 1 - Original README (last 5 lines):"
echo "$readme_original"
echo ""

# Step 3: Apply escape function  
readme_escaped=$(cat ../whip.sh/README.md | escape_myst_for_display)
echo "Step 2 - After escape_myst_for_display (last 5 lines):"
echo "$readme_escaped" | tail -5
echo ""

# Step 4: Pass through jq
json_file="/tmp/test-jq-$$.json"
jq -n --arg readme "$readme_escaped" '{readme_content: $readme}' > "$json_file"
echo "Step 3 - After jq --arg (last 5 lines of readme_content):"
jq -r '.readme_content' "$json_file" | tail -5
echo ""

# Step 5: Pass through myst
cat > /tmp/test-template-$$.myst << 'EOF'
<html><body>
<div id="readme">{{{readme_content}}}</div>
</body></html>
EOF

output_file="/tmp/test-output-$$.html"
bash .arty/bin/myst -j "$json_file" -o "$output_file" /tmp/test-template-$$.myst 2>&1 | grep -v "^\["

echo "Step 4 - After myst.sh processing:"
if [ -f "$output_file" ]; then
    grep -o '<div id="readme">.*</div>' "$output_file" | tail -c 200
    echo ""
    echo ""
    
    if grep -q "{{" "$output_file"; then
        echo "❌ PROBLEM: Output contains {{"
        grep "{{" "$output_file"
    else
        echo "✅ Output does not contain {{"
    fi
    
    if grep -q "&#123;&#123;" "$output_file"; then
        echo "✅ Output contains &#123;&#123;"
    else
        echo "❌ Output does not contain &#123;&#123;"
    fi
else
    echo "❌ Myst failed to create output"
fi

# Cleanup
rm -f "$json_file" /tmp/test-template-$$.myst "$output_file"
