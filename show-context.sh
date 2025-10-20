#!/usr/bin/env bash

echo "Getting full context of the {{ patterns:"
echo ""
grep -B2 -A2 "{{" /tmp/working-test/index.html | head -50
