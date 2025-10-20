#!/usr/bin/env bash

test="Code: `echo hello`"
echo "Input: $test"

result=$(printf '%s' "$test" | sed 's/`/\\\\`/g')
echo "Output: $result"
echo ""

# Check what we actually got
echo "Byte by byte:"
printf '%s' "$result" | od -An -tx1c
