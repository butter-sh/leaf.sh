#!/usr/bin/env bash

echo "Finding the 16 unprocessed {{ patterns:"
echo ""
grep -n "{{" /tmp/working-test/index.html
