#!/usr/bin/env bash

cd "$(dirname "$0")"

echo "=== Detailed myst.sh test ==="
echo ""

# Source the function
source ./leaf.sh 2>/dev/null

# Get and escape README
readme_escaped=$(cat ../whip.sh/README.md | escape_myst_for_display)

# Create JSON
json_file="/tmp/test-myst-detail-$$.json"
jq -n --arg readme "$readme_escaped" '{readme_content: $readme}' > "$json_file"

echo "JSON file size: $(wc -c < "$json_file") bytes"
echo ""

# Create template
cat > /tmp/test-template-$$.myst << 'EOF'
<html><body>
<div id="readme">{{{readme_content}}}</div>
</body></html>
EOF

# Run myst with full output
output_file="/tmp/test-output-$$.html"
echo "Running myst.sh..."
bash .arty/bin/myst -j "$json_file" -o "$output_file" /tmp/test-template-$$.myst

echo ""
if [ -f "$output_file" ]; then
    echo "Output file size: $(wc -c < "$output_file") bytes"
    echo ""
    echo "First 500 chars:"
    head -c 500 "$output_file"
    echo ""
    echo ""
    echo "Last 500 chars:"
    tail -c 500 "$output_file"
    echo ""
    echo ""
    
    echo "Checking for patterns:"
    echo "  Contains {{ : $(grep -c '{{' "$output_file" || echo 0)"
    echo "  Contains &#123;&#123; : $(grep -c '&#123;&#123;' "$output_file" || echo 0)"
    echo "  Contains ## Author : $(grep -c '## Author' "$output_file" || echo 0)"
    
    if grep -q "## Author" "$output_file"; then
        echo ""
        echo "Context around ## Author:"
        grep -A2 -B2 "## Author" "$output_file"
    fi
else
    echo "❌ Output file not created"
fi

# Cleanup
rm -f "$json_file" /tmp/test-template-$$.myst "$output_file"
