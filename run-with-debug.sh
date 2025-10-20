#!/usr/bin/env bash

cd "$(dirname "$0")"

echo "Running leaf.sh with DEBUG=1..."
echo ""

DEBUG=1 bash leaf.sh ../whip.sh -o /tmp/working-test 2>&1 | grep -A2 -B2 "README"

echo ""
echo "Checking output:"
count=$(grep -o "{{" /tmp/working-test/index.html | wc -l | tr -d ' ')
echo "Found $count instances of {{"
