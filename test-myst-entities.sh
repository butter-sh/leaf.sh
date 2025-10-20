#!/usr/bin/env bash

cd "$(dirname "$0")"

echo "Testing how myst.sh handles HTML entities..."
echo ""

# Create a test template
cat > /tmp/myst-entity-test.myst << 'EOF'
<html>
<body>
<p>Content: {{{content}}}</p>
</body>
</html>
EOF

# Create test data with HTML entities
cat > /tmp/myst-entity-data.json << 'EOF'
{
  "content": "Author: &#123;&#123;author&#125;&#125;"
}
EOF

echo "Template:"
cat /tmp/myst-entity-test.myst
echo ""

echo "Data:"
cat /tmp/myst-entity-data.json
echo ""

echo "Myst output:"
bash .arty/bin/myst -j /tmp/myst-entity-data.json /tmp/myst-entity-test.myst

echo ""
echo ""
echo "Checking if output contains {{:"
output=$(bash .arty/bin/myst -j /tmp/myst-entity-data.json /tmp/myst-entity-test.myst)
if echo "$output" | grep -q "{{"; then
    echo "❌ Output contains {{"
    echo "$output"
else
    echo "✅ Output does not contain {{"
fi
