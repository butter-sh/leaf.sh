#!/usr/bin/env bash

# Test myst conditionals

cat > /tmp/test-cond.json <<'EOF'
{
  "has_examples": "false",
  "project_name": "test"
}
EOF

cat > /tmp/test-cond.myst <<'EOF'
<div>
{{#if project_name}}
Project exists
{{/if}}
{{#if has_examples}}
Has examples
{{/if}}
Done
</div>
EOF

echo "=== Testing myst conditionals ==="
bash .arty/bin/myst -j /tmp/test-cond.json /tmp/test-cond.myst

echo ""
echo "---"
echo "Expected: Should show 'Project exists' but NOT 'Has examples'"
