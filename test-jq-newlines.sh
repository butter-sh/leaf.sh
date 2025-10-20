#!/usr/bin/env bash

# Debug what jq actually returns

cat > /tmp/test-jq.json <<'EOF'
{
  "key1": "value1",
  "multiline": "line1\nline2\nline3"
}
EOF

echo "=== What jq returns for multiline value ==="
jq -r '.multiline' /tmp/test-jq.json

echo ""
echo "=== Raw output (with cat -A to show newlines) ==="
jq -r '.multiline' /tmp/test-jq.json | cat -A

echo ""
echo "=== Using to_entries format (what myst uses) ==="
jq -r 'to_entries | .[] | "\(.key)=\(.value)"' /tmp/test-jq.json

echo ""
echo "=== Just the multiline one ==="
jq -r 'to_entries | .[] | select(.key == "multiline") | "\(.key)=\(.value)"' /tmp/test-jq.json | cat -A
