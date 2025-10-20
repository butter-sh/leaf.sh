#!/usr/bin/env bash
# test-jq-command.sh - Test the jq command that generates JSON

cd "$(dirname "${BASH_SOURCE[0]}")"

echo "Testing jq JSON generation..."
echo ""

# Simulate what leaf.sh does
project_name="test-project"
project_version="1.0.0"
project_desc="Test description"
icon_svg='<svg>test</svg>'
readme_content="# Test README"
github_url="https://github.com/test"
base_path="/"
src_html="<div>test source</div>"
ex_html="<div>test examples</div>"

echo "Running jq command..."
jq -n \
  --arg name "$project_name" \
  --arg version "$project_version" \
  --arg desc "$project_desc" \
  --arg icon "$icon_svg" \
  --arg readme "$readme_content" \
  --arg github "$github_url" \
  --arg base "$base_path" \
  --arg src_html "$src_html" \
  --arg ex_html "$ex_html" \
  '{
    page_title: ($name + " - Documentation"),
    page_description: $desc,
    base_path: $base,
    project_name: $name,
    project_version: $version,
    project_description: $desc,
    icon: $icon,
    readme_content: $readme,
    github_url: $github,
    source_files_html: $src_html,
    examples_html: $ex_html,
    myst_enabled: "true"
  }' > /tmp/test-jq-output.json

echo ""
if jq empty /tmp/test-jq-output.json 2>/dev/null; then
    echo "✅ JSON is valid"
    echo ""
    echo "Content:"
    cat /tmp/test-jq-output.json | jq .
else
    echo "❌ JSON is invalid"
    echo ""
    echo "Raw content:"
    cat /tmp/test-jq-output.json
fi
