<div align="center">

# 🍃 leaf.sh

**Beautiful Documentation and Landing Page Generator**

[![Organization](https://img.shields.io/badge/org-butter--sh-4ade80?style=for-the-badge&logo=github&logoColor=white)](https://github.com/butter-sh)
[![License](https://img.shields.io/badge/license-MIT-86efac?style=for-the-badge)](LICENSE)
[![Build Status](https://img.shields.io/github/actions/workflow/status/butter-sh/leaf.sh/test.yml?branch=main&style=flat-square&logo=github)](https://github.com/butter-sh/leaf.sh/actions)
[![Version](https://img.shields.io/github/v/tag/butter-sh/leaf.sh?style=flat-square&label=version&color=4ade80)](https://github.com/butter-sh/leaf.sh/releases)
[![butter.sh](https://img.shields.io/badge/butter.sh-leaf-22c55e?style=flat-square&logo=data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cGF0aCBkPSJNMjEgMTZWOGEyIDIgMCAwIDAtMS0xLjczbC03LTRhMiAyIDAgMCAwLTIgMGwtNyA0QTIgMiAwIDAgMCAzIDh2OGEyIDIgMCAwIDAgMSAxLjczbDcgNGEyIDIgMCAwIDAgMiAwbDctNEEyIDIgMCAwIDAgMjEgMTZ6IiBzdHJva2U9IiM0YWRlODAiIHN0cm9rZS13aWR0aD0iMiIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIi8+PHBvbHlsaW5lIHBvaW50cz0iMy4yNyA2Ljk2IDEyIDEyLjAxIDIwLjczIDYuOTYiIHN0cm9rZT0iIzRhZGU4MCIgc3Ryb2tlLXdpZHRoPSIyIiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiLz48bGluZSB4MT0iMTIiIHkxPSIyMi4wOCIgeDI9IjEyIiB5Mj0iMTIiIHN0cm9rZT0iIzRhZGU4MCIgc3Ryb2tlLXdpZHRoPSIyIiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiLz48L3N2Zz4=)](https://butter-sh.github.io/leaf.sh)

*Transform projects into beautiful documentation websites with responsive design and modern themes*

[Documentation](https://butter-sh.github.io/leaf.sh) • [GitHub](https://github.com/butter-sh/leaf.sh) • [butter.sh](https://github.com/butter-sh)

</div>

---

## Features

- **Documentation Mode**: Generate beautiful static HTML documentation from arty.sh projects
  - Automatically extracts project metadata from arty.yml
  - Renders README.md with syntax highlighting
  - Displays source files with code highlighting
  - Showcases examples in an attractive format
  - Modern responsive design with dark/light theme toggle

- **Landing Page Mode**: Create stylish landing pages for butter.sh
  - Modern minimalistic carbon theme
  - Hero section with gradient CTA buttons
  - Responsive header with mobile menu
  - Theme switcher (dark/light mode)
  - Project cards with hover effects
  - Customizable project list via JSON

- **Powered by myst.sh**: Uses the myst.sh templating engine for flexible, maintainable templates

## Installation

### Using hammer.sh

```bash
hammer leaf my-docs
cd my-docs
```

### Using arty.sh

```bash
# Add to your arty.yml
references:
  - https://github.com/butter-sh/leaf.sh.git

# Install dependencies
arty deps

# Use via arty
arty exec leaf --help
```

### Manual Install

```bash
# Clone or download leaf.sh
git clone https://github.com/butter-sh/leaf.sh.git
cd leaf.sh

# Make executable
chmod +x leaf.sh
```

## Dependencies

- **yq** - YAML parser (required)
- **jq** - JSON processor (required)
- **myst.sh** - Templating engine (required, install via arty.sh)

Install yq: https://github.com/mikefarah/yq#install  
Install jq: https://stedolan.github.io/jq/download/

## Usage

### Generate Documentation

```bash
# Generate docs for current directory
./leaf.sh .

# Generate docs for specific project
./leaf.sh /path/to/project --logo ./icon.svg

# Custom output directory
./leaf.sh /path/to/project -o ./public
```

### Generate Landing Page

```bash
# Generate landing page with default projects
./leaf.sh --landing --github https://github.com/my-org

# Generate landing with custom projects from file
./leaf.sh --landing --projects-file ./projects.json

# Generate landing with custom logo
./leaf.sh --landing --logo ./brand-logo.svg
```

## Options

- `--landing` - Generate butter.sh landing page instead of docs
- `--logo PATH` - Path to logo/icon file
- `--base-path PATH` - Base path for HTML links (default: /)
- `--github URL` - GitHub organization URL
- `--projects JSON` - JSON array of projects
- `--projects-file FILE` - JSON file containing projects
- `-o, --output DIR` - Output directory (default: docs)
- `-h, --help` - Show help message
- `--debug` - Enable debug output

## Projects JSON Format

For landing page mode, projects JSON should be an array:

```json
[
  {
    "url": "https://project.com",
    "label": "Project Name",
    "desc": "Project description",
    "class": "card-project"
  }
]
```

## Examples

```bash
# Generate docs for whip.sh
./leaf.sh ../whip.sh --logo ../whip.sh/icon.svg -o ../whip.sh/docs

# Generate butter.sh landing page
./leaf.sh --landing \
  --projects-file ./projects.json \
  --logo ./brand/logo.svg \
  --github https://github.com/butter-sh \
  -o ./dist

# Generate docs for arty.sh project
./leaf.sh /path/to/arty-project

# Generate docs with custom base path (for GitHub Pages)
./leaf.sh . --base-path /my-repo/
```

## Templates

Templates are located in `templates/` directory:

- `docs.html.myst` - Documentation page template
- `landing.html.myst` - Landing page template
- `partials/` - Reusable template components
  - `_head.myst` - HTML head section
  - `_header.myst` - Navigation header
  - `_footer.myst` - Page footer
  - `_carbon_styles.myst` - Carbon theme styles
  - `_common_scripts.myst` - JavaScript utilities

## Project Structure

For best results, structure your arty.sh project like this:

```
your-project/
├── arty.yml           # Project metadata
├── README.md          # Main documentation
├── LICENSE            # License file
├── main.sh            # Source files
├── _assets/
│   └── icon/
│       └── icon.svg   # Project icon
└── examples/
    └── usage.sh       # Example files
```

## Supported File Types

Shell (.sh, .bash), JavaScript (.js), TypeScript (.ts), Python (.py), 
Ruby (.rb), Go (.go), Rust (.rs), Java (.java), C/C++ (.c, .h, .cpp, .hpp)

## Integration with butter.sh

leaf.sh works seamlessly with other butter.sh tools:

```bash
# Generate project with hammer.sh
hammer arty my-library

# Generate documentation with leaf.sh
cd my-library
arty install https://github.com/butter-sh/leaf.sh.git
arty exec leaf .

# Open the generated documentation
open docs/index.html

# Test with judge.sh
arty install https://github.com/butter-sh/judge.sh.git
arty exec judge run

# Manage releases with whip.sh
arty install https://github.com/butter-sh/whip.sh.git
arty exec whip release
```

## Advanced Usage

### Custom Templates

Create custom templates by modifying files in the `templates/` directory:

```bash
# Copy and modify a template
cp templates/docs.html.myst templates/my-custom.html.myst

# Edit the template
nano templates/my-custom.html.myst

# Use with leaf.sh (may require code modifications)
```

### Batch Documentation Generation

```bash
#!/usr/bin/env bash

# Generate docs for multiple projects
for project in projects/*; do
  if [ -f "$project/arty.yml" ]; then
    echo "Generating docs for $project"
    ./leaf.sh "$project" -o "public/$(basename $project)"
  fi
done
```

### CI/CD Integration

```yaml
# .github/workflows/docs.yml
name: Generate Documentation

on:
  push:
    branches: [ main ]

jobs:
  docs:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Install dependencies
        run: |
          sudo apt-get update
          sudo apt-get install -y jq
          sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
          sudo chmod +x /usr/local/bin/yq
          
      - name: Install arty.sh and dependencies
        run: |
          curl -sSL https://raw.githubusercontent.com/butter-sh/arty.sh/main/arty.sh | sudo tee /usr/local/bin/arty > /dev/null
          sudo chmod +x /usr/local/bin/arty
          arty deps
          
      - name: Generate documentation
        run: |
          arty exec leaf . -o public
          
      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./public
```

## Related Projects

Part of the butter.sh ecosystem:

- **[arty.sh](https://github.com/butter-sh/arty.sh)** - Bash library dependency manager
- **[hammer.sh](https://github.com/butter-sh/hammer.sh)** - Project generator from templates
- **[judge.sh](https://github.com/butter-sh/judge.sh)** - Testing framework with assertions
- **[whip.sh](https://github.com/butter-sh/whip.sh)** - Release cycle management
- **[myst.sh](https://github.com/butter-sh/myst.sh)** - Templating engine

## License

MIT License - See [LICENSE](LICENSE) file for details

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Author

Created by [valknar](https://github.com/valknarogg)

---

<div align="center">

Part of the [butter.sh](https://github.com/butter-sh) ecosystem

**Unlimited. Independent. Fresh.**

</div>
