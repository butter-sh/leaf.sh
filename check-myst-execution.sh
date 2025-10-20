#!/usr/bin/env bash

cd "$(dirname "$0")"

echo "=== Checking if myst.sh was actually called during generation ==="
echo ""

rm -rf /tmp/working-test
echo "Running leaf.sh with verbose output..."
DEBUG=1 bash leaf.sh ../whip.sh -o /tmp/working-test 2>&1 | tee /tmp/leaf-run.log

echo ""
echo "=== Checking for myst execution ==="
grep -i "myst" /tmp/leaf-run.log

echo ""
echo "=== Checking for any errors ==="
grep -i "error\|fail" /tmp/leaf-run.log

echo ""
echo "=== Checking the actual myst command that was run ==="
grep "Running:" /tmp/leaf-run.log
