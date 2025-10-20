#!/usr/bin/env bash

echo "=== Checking what {{ patterns remain ==="
echo ""
grep -n "{{" /tmp/working-test/index.html
echo ""
echo "=== With context ==="
grep -B3 -A3 "{{" /tmp/working-test/index.html
