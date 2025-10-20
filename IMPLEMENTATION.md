# leaf.sh Project - Complete Rework Summary

## Overview

This is a complete rework of leaf.sh that fixes the HTML escaping issue with myst.sh and provides a clean, working implementation for generating documentation for arty.sh projects and landing pages for butter.sh.

## Key Changes from Original

### 1. **Proper HTML Escaping**
- Added `escape_html()` function that properly escapes HTML special characters
- Code content is now escaped BEFORE being inserted into HTML templates
- This prevents myst.sh from receiving unescaped HTML that could break templates
- Used for both source files and examples

### 2. **Simplified Code Structure**
- Removed unnecessary complexity
- Cleaner separation between documentation and landing page generation
- Better error handling and logging
- More maintainable codebase

### 3. **Fixed myst.sh Integration**
- Template file paths are passed correctly to myst.sh (not file contents)
- JSON data is properly escaped using `jq`
- All variables are safely passed through JSON without shell expansion issues

### 4. **Modern Templates**
- `docs.html.myst` - Clean documentation template with syntax highlighting
- `landing.html.myst` - Modern carbon-themed landing page
- Reusable partials for consistent styling
- Responsive design with dark/light mode support

## Project Structure

```
leaf.sh/
├── arty.yml                          # Project configuration
├── leaf.sh                           # Main script (executable)
├── README.md                         # Documentation
├── LICENSE                           # MIT License
├── icon.svg                          # Project icon
├── .gitignore                        # Git ignore rules
├── examples/                         # Usage examples
│   ├── generate-docs.sh
│   ├── generate-landing.sh
│   └── inline-projects.sh
└── templates/                        # Template files
    ├── docs.html.myst               # Documentation template
    ├── landing.html.myst            # Landing page template
    ├── examples/
    │   └── projects.json            # Sample projects data
    └── partials/                    # Reusable components
        ├── _head.myst
        ├── _header.myst
        ├── _footer.myst
        ├── _carbon_styles.myst
        └── _common_scripts.myst
```

## Features

### Documentation Mode
- Generates beautiful static HTML from arty.sh projects
- Extracts metadata from arty.yml
- Renders README.md with markdown support
- Displays source files with syntax highlighting
- Shows examples in organized cards
- Responsive design with theme toggle

### Landing Page Mode
- Modern carbon-themed design
- Hero section with gradient CTAs
- Project cards with hover effects
- Mobile-friendly responsive layout
- Configurable via JSON

## Usage

### Generate Documentation
```bash
# For current directory
./leaf.sh

# For specific project
./leaf.sh /path/to/project --logo ./icon.svg -o ./docs
```

### Generate Landing Page
```bash
# With projects file
./leaf.sh --landing --projects-file ./projects.json -o ./output

# With inline JSON
./leaf.sh --landing --projects '[{...}]' -o ./output
```

## Technical Details

### HTML Escaping Function
```bash
escape_html() {
  local text="$1"
  echo "$text" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g; s/'"'"'/\&#39;/g'
}
```

This function:
- Replaces `&` with `&amp;`
- Replaces `<` with `&lt;`
- Replaces `>` with `&gt;`
- Replaces `"` with `&quot;`
- Replaces `'` with `&#39;`

### Data Flow
1. Read source files
2. Escape HTML characters in code
3. Build HTML structure with escaped code
4. Pass all data through jq to create JSON
5. Pass JSON file to myst.sh
6. myst.sh renders template with data
7. Output final HTML

### Why This Works
- Code is pre-escaped, so `<script>` becomes `&lt;script&gt;`
- HTML structure uses triple braces `{{{...}}}` in templates for raw HTML
- myst.sh doesn't need to escape, just inserts the content
- Result: Clean, highlighted code blocks that don't break HTML

## Dependencies

- **bash** - Shell interpreter
- **yq** - YAML parser
- **jq** - JSON processor
- **myst.sh** - Templating engine

## Installation

1. Clone or copy the leaf.sh project
2. Install dependencies (yq, jq, myst.sh)
3. Make leaf.sh executable: `chmod +x leaf.sh`
4. Run: `./leaf.sh --help`

## Comparison with Original

| Aspect | Original | New Version |
|--------|----------|-------------|
| HTML Escaping | Broken | Fixed with escape_html() |
| Code Structure | Complex | Simplified |
| Error Handling | Basic | Improved |
| Templates | Mixed | Clean separation |
| Documentation | Minimal | Comprehensive |
| Examples | Few | Multiple clear examples |

## Testing

To test the new implementation:

```bash
# Test documentation generation
./leaf.sh . -o ./test-docs

# Test landing page
./leaf.sh --landing --projects-file ./templates/examples/projects.json -o ./test-landing

# View results
open test-docs/index.html
open test-landing/index.html
```

## Future Enhancements

- Add more template themes
- Support for custom CSS injection
- Multi-page documentation support
- Table of contents generation
- Search functionality
- PDF export option

## Conclusion

This reworked version of leaf.sh provides:
- ✅ Proper HTML escaping (fixes the main bug)
- ✅ Clean, maintainable code
- ✅ Better error handling
- ✅ Comprehensive documentation
- ✅ Working examples
- ✅ Modern, responsive templates
- ✅ Easy to extend and customize

The project is now ready for use with arty.sh projects and butter.sh landing pages!
