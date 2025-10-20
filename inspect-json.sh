#!/usr/bin/env bash
# inspect-json.sh - Inspect the JSON data being passed to myst

cd "$(dirname "${BASH_SOURCE[0]}")"

echo "Inspecting JSON data file..."
echo ""

# Find the most recent leaf_docs JSON file
json_file=$(ls -t /tmp/leaf_docs_*.json 2>/dev/null | head -1)

if [[ -z "$json_file" ]]; then
    echo "No JSON file found. Generating one..."
    bash leaf.sh ../whip.sh -o /tmp/inspect-test >/dev/null 2>&1
    json_file=$(ls -t /tmp/leaf_docs_*.json 2>/dev/null | head -1)
fi

if [[ -f "$json_file" ]]; then
    echo "Found: $json_file"
    echo "Size: $(wc -c < "$json_file") bytes"
    echo ""
    
    echo "━━━ JSON Structure ━━━"
    jq 'keys' "$json_file"
    echo ""
    
    echo "━━━ Source HTML Length ━━━"
    jq -r '.source_files_html | length' "$json_file"
    echo "characters"
    echo ""
    
    echo "━━━ First 500 chars of source_files_html ━━━"
    jq -r '.source_files_html' "$json_file" | head -c 500
    echo ""
    echo "..."
    echo ""
    
    echo "━━━ README content (first 200 chars) ━━━"
    jq -r '.readme_content' "$json_file" | head -c 200
    echo ""
    echo "..."
    echo ""
    
    # Check if source_files_html has actual code
    if jq -r '.source_files_html' "$json_file" | grep -q '<code class="language-bash"></code>'; then
        echo "⚠️  Found empty code blocks in JSON!"
        echo ""
        echo "Checking first few code blocks:"
        jq -r '.source_files_html' "$json_file" | grep -o '<code class="language-[^"]*">[^<]*</code>' | head -3
    else
        echo "✅ Code blocks appear to have content in JSON"
    fi
else
    echo "❌ No JSON file found"
fi
