#!/usr/bin/env bash

echo "Running with DEBUG=1..."
rm -rf /tmp/working-test
DEBUG=1 bash leaf.sh ../whip.sh -o /tmp/working-test 2>&1 | tee /tmp/leaf-debug.log

echo ""
echo "=== Extracted DEBUG output ==="
grep "🔍" /tmp/leaf-debug.log | grep -i readme

echo ""
echo "=== Checking results ==="
bash check-debug-json.sh
echo ""
bash show-patterns.sh | head -20
