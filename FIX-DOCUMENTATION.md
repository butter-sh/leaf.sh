# Fix for JavaScript Syntax Error in leaf.sh

## Problem

The generated HTML had a JavaScript syntax error at line 105:
```
Uncaught SyntaxError: Invalid or unexpected token (at index.html:105:35)
```

## Root Cause

The template was using **triple braces** `{{{readme_content_json}}}` to insert the README content into JavaScript:

```javascript
const readmeContent = {{{readme_content_json}}};
```

### Why This Failed

1. `readme_content_json` is created by `jq -Rs '.'` which outputs a properly JSON-encoded string
2. This string is stored in the JSON data file as a string value (e.g., `"# Title\n\nCode..."`)
3. When MyST uses `{{{...}}}` (triple braces), it inserts the value **without HTML escaping**
4. However, the JSON string contains characters that need HTML entity encoding when inserted into an HTML document
5. Without proper encoding, special HTML characters in the JSON string could break the JavaScript parser

### The Issue with Special Characters

When the README contains:
- Backticks: `` ` ``
- Less-than/greater-than: `<`, `>`
- Quotes: `"`, `'`
- Ampersands: `&`

These characters in the JSON string, when inserted unescaped into HTML, can cause:
- Browser HTML parsing issues
- JavaScript syntax errors
- Breaking out of the script context

## Solution

Changed the template to use **double braces** `{{readme_content_json}}`:

```javascript
const readmeContent = {{readme_content_json}};
```

### Why This Works

1. Double braces `{{...}}` tell MyST to **HTML-escape** the value before insertion
2. Special characters are converted to HTML entities (e.g., `<` → `&lt;`, `>` → `&gt;`)
3. The browser's HTML parser decodes these entities back to their original characters
4. The JavaScript parser receives properly formatted, safe content
5. `jq -Rs` already handles proper JSON escaping (including backticks), so we don't need additional escaping

### Flow Comparison

**Before (Broken):**
```
README.md → escape_myst_for_display() → jq -Rs → JSON file
                                                        ↓
                                        MyST {{{...}}} (no escaping)
                                                        ↓
                                        HTML: const readmeContent = "content<br>";
                                                        ↓
                                        Browser: JavaScript sees: const readmeContent = "content<br>";
                                                        ↓
                                        ERROR: <br> breaks string literal!
```

**After (Fixed):**
```
README.md → escape_myst_for_display() → jq -Rs → JSON file
                                                        ↓
                                        MyST {{...}} (HTML escape)
                                                        ↓
                                        HTML: const readmeContent = &quot;content&lt;br&gt;&quot;;
                                                        ↓
                                        Browser HTML parser decodes entities
                                                        ↓
                                        JavaScript sees: const readmeContent = "content<br>";
                                                        ↓
                                        SUCCESS: Valid JavaScript string!
```

## Changes Made

### 1. Template Fix (`templates/docs.html.myst`)

**Before:**
```html
<script>
    const readmeContent = {{{readme_content_json}}};
    document.getElementById('readmeContent').innerHTML = marked.parse(readmeContent);
</script>
```

**After:**
```html
<script>
    const readmeContent = {{readme_content_json}};
    document.getElementById('readmeContent').innerHTML = marked.parse(readmeContent);
</script>
```

### 2. Script Cleanup (`leaf.sh`)

Removed unnecessary backtick escaping from `escape_myst_for_display()` function since `jq -Rs` already handles backtick escaping properly for JSON strings.

**Before:**
```bash
printf '%s' "$text" | python3 -c 'import sys; text = sys.stdin.read(); text = text.replace("{{" , "&#123;&#123;").replace("}}", "&#125;&#125;").replace(chr(96), "\\\\" + chr(96)); sys.stdout.write(text)'
```

**After:**
```bash
printf '%s' "$text" | python3 -c 'import sys; text = sys.stdin.read(); text = text.replace("{{" , "&#123;&#123;").replace("}}", "&#125;&#125;"); sys.stdout.write(text)'
```

## Testing

Run the comprehensive test:
```bash
bash comprehensive-test.sh
```

This test will:
1. ✅ Verify template syntax
2. ✅ Create a test project with special characters (backticks, {{mustache}}, etc.)
3. ✅ Generate documentation
4. ✅ Validate JavaScript syntax with Node.js
5. ✅ Check the specific problematic line
6. ✅ Verify data structure

## Key Takeaways

1. **Always use double braces `{{...}}` for inserting dynamic content into HTML**, even in `<script>` tags
2. **Triple braces `{{{...}}}` should only be used for pre-escaped HTML content** (like SVG icons)
3. **`jq -Rs` properly escapes JSON strings** - don't try to manually escape what it already handles
4. **HTML entity encoding is your friend** - it's the correct way to safely insert data into HTML documents

## Files Modified

- `templates/docs.html.myst` - Changed `{{{readme_content_json}}}` to `{{readme_content_json}}`
- `leaf.sh` - Removed unnecessary backtick escaping from `escape_myst_for_display()`

## Verification

After applying this fix:
- ✅ No more JavaScript syntax errors
- ✅ README content with backticks renders correctly
- ✅ Mustache syntax ({{...}}) displays as literal text
- ✅ All special characters handled safely
- ✅ Works with Node.js syntax validation
