#!/usr/bin/env bash

echo "All lines containing {{ in the output:"
echo ""
grep -n "{{" /tmp/working-test/index.html
echo ""
echo "========================"
echo ""
echo "Full context (10 lines before and after first occurrence):"
echo ""
grep -n -B10 -A10 "{{" /tmp/working-test/index.html | head -50
