#!/usr/bin/env bash

# Test what myst does with undefined variables
cd "$(dirname "$0")"

cat > /tmp/myst-test-template.myst << 'EOF'
Hello {{defined_var}}!
And here is {{undefined_var}}.
Triple: {{{another_undefined}}}.
EOF

cat > /tmp/myst-test-data.json << 'EOF'
{
  "defined_var": "World"
}
EOF

echo "Template:"
cat /tmp/myst-test-template.myst
echo ""
echo "Data:"
cat /tmp/myst-test-data.json
echo ""
echo "Output:"
bash .arty/bin/myst -j /tmp/myst-test-data.json /tmp/myst-test-template.myst
