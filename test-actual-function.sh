#!/usr/bin/env bash

cd "$(dirname "$0")"

# Source and test the actual function
source ./leaf.sh 2>/dev/null

test='Code `example` and {{author}}'
echo "Testing escape_myst_for_display function:"
echo "Input: $test"
echo ""

result=$(escape_myst_for_display "$test")
echo "Output: $result"
echo ""

if [[ "$result" == *'\`'* ]]; then
    echo "✅ Function produces escaped backticks"
else
    echo "❌ Function doesn't escape backticks"
fi

# Also test with actual README snippet
echo ""
echo "Testing with README snippet:"
readme_snippet='## Installation

```bash
hammer.sh whip my-project
```

## Author
{{author}}'

result2=$(escape_myst_for_display "$readme_snippet")
echo "Length: ${#result2} chars"
echo ""
echo "Contains \\`: $(echo "$result2" | grep -c '\\`' || echo 0)"
echo "Contains unescaped \`: $(echo "$result2" | grep -o '`' | wc -l || echo 0)"
echo "Contains &#123;&#123;: $(echo "$result2" | grep -c '&#123;&#123;' || echo 0)"
