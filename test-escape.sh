#!/usr/bin/env bash

# Test what the escaping produces
cd "$(dirname "$0")"

source ./leaf.sh

# Test the escape function
test_content="This has {{author}} and {{version}} templates"
echo "Original:"
echo "$test_content"
echo ""

echo "After escape_myst_syntax:"
escaped=$(escape_myst_syntax "$test_content")
echo "$escaped"
echo ""

# Now let's see what happens in a JavaScript context
echo "In JavaScript backtick string:"
echo "\`$escaped\`"
