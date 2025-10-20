#!/usr/bin/env bash

echo "Finding all {{ instances in the generated HTML:"
echo ""

grep -n "{{" /tmp/working-test/index.html

echo ""
echo "Context around each instance:"
echo ""

grep -B2 -A2 "{{" /tmp/working-test/index.html
