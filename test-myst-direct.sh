#!/usr/bin/env bash

cd "$(dirname "$0")"

echo "Testing myst.sh directly with actual files..."
echo ""

if [ ! -f /tmp/working-test/debug-data.json ]; then
    echo "Generating data first..."
    bash leaf.sh ../whip.sh -o /tmp/working-test 2>&1 | grep -E "(ℹ|✓)"
    echo ""
fi

myst_path=".arty/bin/myst"
template="./templates/docs.html.myst"
json_file="/tmp/working-test/debug-data.json"
output_file="/tmp/test-direct-myst-output.html"

echo "Myst: $myst_path"
echo "Template: $template"
echo "JSON: $json_file"
echo "Output: $output_file"
echo ""

echo "Running myst.sh directly..."
bash "$myst_path" -j "$json_file" -p "./templates/partials" -o "$output_file" "$template"
exit_code=$?

echo ""
echo "Exit code: $exit_code"
echo ""

if [ -f "$output_file" ]; then
    echo "Output file created, size: $(wc -c < "$output_file") bytes"
    echo ""
    
    echo "Checking for unprocessed {{:"
    count=$(grep -c "{{" "$output_file" || echo 0)
    echo "  Found $count instances"
    
    if [ "$count" -gt 0 ]; then
        echo ""
        echo "  Examples:"
        grep "{{" "$output_file" | head -3
    fi
else
    echo "❌ No output file created"
fi
