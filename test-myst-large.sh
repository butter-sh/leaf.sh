#!/usr/bin/env bash

# Test if myst.sh can handle large HTML content with newlines

# Create a test JSON with properly escaped newlines
cat > /tmp/test-large.json <<'EOF'
{
  "title": "Test",
  "large_html": "<div>Line 1</div>\n<div>Line 2</div>\n<div>Line 3</div>\n<div>Line 4</div>\n<div>Line 5</div>"
}
EOF

# Verify it's valid JSON
echo "=== Validating JSON ==="
jq . /tmp/test-large.json > /dev/null && echo "JSON is valid" || echo "JSON is invalid"

# Create a test template
cat > /tmp/test-template.myst <<'EOF'
<html>
<head><title>{{title}}</title></head>
<body>
{{{large_html}}}
</body>
</html>
EOF

echo ""
echo "=== Rendering template ==="
# Render with myst
bash .arty/bin/myst -j /tmp/test-large.json /tmp/test-template.myst

echo ""
echo "---"
echo "Expected to see 5 divs above"
