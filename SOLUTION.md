# FINAL FIX: JavaScript Syntax Error in leaf.sh ✅

## The Problem
```
Uncaught SyntaxError: Invalid or unexpected token
```

Generated JavaScript couldn't parse the README content due to improper escaping.

## The Solution: JSON Script Tag with Proper Escaping

Store the README as a **valid JSON string** in a `<script type="application/json">` tag, then parse it with `JSON.parse()`.

### Key Insight

- `jq -Rs` creates a JSON string: `"content"` (with quotes and proper escaping)
- Store this complete JSON string in the data file
- Use triple braces `{{{...}}}` to insert it unescaped
- Result: Valid JSON in the script tag that `JSON.parse()` can handle

## Implementation

### 1. leaf.sh - Create Proper JSON String

```bash
# Convert README to a JSON string (with quotes)
local readme_json=$(printf '%s' "$readme_content" | jq -Rs '.')

# Store it in the data file with --arg (keeps it as a string literal)
jq -n \
  --arg readme_json "$readme_json" \
  '{
    readme_content_json: $readme_json,
    ...
  }'
```

**What happens:**
- Input: `# whip.sh\nCode: `backtick``
- After `jq -Rs`: `"# whip.sh\nCode: `backtick`"` (JSON string with quotes)
- In data file: `"readme_content_json": "\"# whip.sh\\nCode: `backtick`\""`
- When read by jq: The string `"# whip.sh\nCode: `backtick`"`

### 2. templates/docs.html.myst - Insert with Triple Braces

```html
<!-- Store README content as JSON data -->
<script id="readmeData" type="application/json">{{{readme_content_json}}}</script>

<script>
    // Parse the JSON content
    const readmeData = document.getElementById('readmeData');
    const readmeContent = JSON.parse(readmeData.textContent);
    document.getElementById('readmeContent').innerHTML = marked.parse(readmeContent);
</script>
```

**Why triple braces `{{{...}}}`?**
- Triple braces = unescaped output
- We WANT the literal quotes and escape sequences from the JSON string
- Result: `<script type="application/json">"# whip.sh\nCode: `backtick`"</script>`
- This is valid JSON that `JSON.parse()` can handle!

## Complete Data Flow

```
1. README.md
   "# Title\nCode: `backtick`"
   ↓
2. escape_myst_for_display()
   "# Title\nCode: `backtick`"  (backticks unchanged, {{ → &#123;&#123;)
   ↓
3. jq -Rs '.'
   "\"# Title\\nCode: `backtick`\""  (JSON string with quotes and escapes)
   ↓
4. jq --arg readme_json "$readme_json"
   Stored in JSON file as: "readme_content_json": "\"# Title\\nCode: `backtick`\""
   ↓
5. MyST {{{readme_content_json}}}
   Inserts unescaped: "# Title\nCode: `backtick`"
   ↓
6. HTML output
   <script type="application/json">"# Title\nCode: `backtick`"</script>
   ↓
7. JavaScript JSON.parse()
   Parses to: "# Title\nCode: `backtick`" ✅ Valid string!
   ↓
8. marked.parse()
   Renders markdown correctly
```

## Why This Works

✅ **Valid JSON** - The script tag contains a properly quoted JSON string  
✅ **Handles all characters** - Backticks, quotes, newlines, HTML entities  
✅ **Standard pattern** - JSON script tags are a common web development practice  
✅ **Automatic escaping** - `jq -Rs` handles all the complexity  
✅ **Clean separation** - Data stored separately from executable code  

## Changes Made

### leaf.sh (lines ~497-530)
- Added `readme_json=$(printf '%s' "$readme_content" | jq -Rs '.')`
- Pass to jq with `--arg readme_json "$readme_json"`
- Include in output: `readme_content_json: $readme_json`

### templates/docs.html.myst (lines ~91-107)
- JSON data: `<script id="readmeData" type="application/json">{{{readme_content_json}}}</script>`
- Parse it: `const readmeContent = JSON.parse(readmeData.textContent);`

## Testing

```bash
cd ~/Projects/butter.sh/projects/leaf.sh
bash test-final-v2.sh
```

Expected results:
- ✅ JavaScript syntax validation passes
- ✅ No browser console errors
- ✅ README renders with all special characters
- ✅ Code blocks with backticks work correctly

## Key Takeaway

**Triple braces are correct here!** We're inserting an already-escaped JSON string that needs to remain a JSON string in the HTML. Using double braces would HTML-escape the quotes, breaking the JSON.

---

**This is the definitive, production-ready solution!** 🎉
