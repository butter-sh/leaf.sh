<div align="center">

<img src="./icon.svg" width="100" height="100" alt="leaf.sh">

# leaf.sh

**Documentation Generator**

[![Organization](https://img.shields.io/badge/org-butter--sh-4ade80?style=for-the-badge&logo=github&logoColor=white)](https://github.com/butter-sh)
[![License](https://img.shields.io/badge/license-MIT-86efac?style=for-the-badge)](LICENSE)
[![Version](https://img.shields.io/badge/version-1.0.0-22c55e?style=for-the-badge)](https://github.com/butter-sh/leaf.sh/releases)
[![butter.sh](https://img.shields.io/badge/butter.sh-leaf-4ade80?style=for-the-badge)](https://butter-sh.github.io)

*Beautiful documentation generator that transforms project metadata into responsive, modern static websites*

[Documentation](https://butter-sh.github.io/leaf.sh) • [GitHub](https://github.com/butter-sh/leaf.sh) • [butter.sh](https://github.com/butter-sh)

</div>

---

## Overview

leaf.sh is a documentation generator that transforms arty.yml project metadata into beautiful, responsive HTML documentation websites. Built on myst.sh templating, it automatically generates navigation, styling, and layouts from your project configuration.

### Key Features

- **Responsive Design** — Mobile-first, modern documentation layout
- **Automatic Navigation** — Generated from project structure
- **Syntax Highlighting** — Code blocks with language support
- **Theme Support** — Customizable colors and styles
- **arty.yml Integration** — Reads project metadata automatically
- **Landing Pages** — Generate ecosystem landing pages from projects.json

---

## Installation

### Using arty.sh

```bash
arty install https://github.com/butter-sh/leaf.sh.git
arty exec leaf --help
```

### Manual Installation

```bash
git clone https://github.com/butter-sh/leaf.sh.git
cd leaf.sh
sudo cp leaf.sh /usr/local/bin/leaf
sudo chmod +x /usr/local/bin/leaf
```

---

## System Requirements

- **Bash** 4.0 or higher
- **yq** for YAML processing
- **jq** for JSON processing
- **myst.sh** for templating

---

## Usage

### Generate Project Documentation

```bash
# Generate docs from current directory
leaf . -o docs/

# Generate from specific project
leaf /path/to/project -o output/

# Use custom template
leaf . -o docs/ --template custom.myst
```

### Generate Landing Page

```bash
# Generate from projects.json
leaf --landing --projects projects.json -o index.html

# Use custom URL base
leaf --landing --projects projects.json -o index.html --url https://example.com
```

### Options

```bash
-o, --output DIR      Output directory
-t, --template FILE   Custom template file
--landing             Generate landing page mode
-p, --projects FILE   Projects JSON file (for landing page)
--url URL             Base URL for links
-h, --help            Show help message
```

---

## Documentation Mode

Generate documentation for a project:

```bash
leaf my-project -o docs/
```

Reads from `arty.yml`:
```yaml
name: "my-project"
version: "1.0.0"
description: "A professional bash library"
author: "Your Name"
license: "MIT"
```

Generates:
```
docs/
├── index.html        # Main documentation
├── css/
│   └── style.css     # Styles
└── assets/
    └── icon.svg      # Project icon
```

---

## Landing Page Mode

Generate an ecosystem landing page:

```bash
leaf --landing --projects projects.json -o index.html
```

**projects.json:**
```json
[
  {
    "label": "arty.sh",
    "desc": "Bash dependency manager",
    "url": "https://butter-sh.github.io/arty.sh",
    "icon": "icon icon-package",
    "tagline": "Dependency management"
  },
  {
    "label": "judge.sh",
    "desc": "Testing framework",
    "url": "https://butter-sh.github.io/judge.sh",
    "icon": "icon icon-shield",
    "tagline": "Test automation"
  }
]
```

---

## Examples

### Example 1: Simple Project Docs

```bash
# Initialize project
arty init my-lib
cd my-lib

# Generate documentation
leaf . -o docs/

# Open in browser
open docs/index.html
```

### Example 2: Multi-Project Documentation

```bash
# Generate docs for all projects
for project in projects/*/; do
  leaf "$project" -o "docs/$(basename "$project")"
done

# Generate landing page
leaf --landing --projects projects.json -o docs/index.html
```

### Example 3: CI/CD Integration

```yaml
# .github/workflows/docs.yml
name: Generate Docs
on: [push]
jobs:
  docs:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Install dependencies
        run: |
          sudo apt-get install yq jq
      - name: Install leaf.sh
        run: |
          git clone https://github.com/butter-sh/leaf.sh.git
          sudo cp leaf.sh/leaf.sh /usr/local/bin/leaf
      - name: Generate documentation
        run: leaf . -o docs/
      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./docs
```

---

## Integration with arty.sh

Add leaf.sh to your project:

```yaml
name: "my-project"
version: "1.0.0"

references:
  - https://github.com/butter-sh/leaf.sh.git
  - https://github.com/butter-sh/myst.sh.git

scripts:
  docs: "arty exec leaf . -o docs/"
  docs-landing: "arty exec leaf --landing --projects projects.json -o index.html"
```

Then run:

```bash
arty deps      # Install leaf.sh and myst.sh
arty docs      # Generate documentation
```

---

## Custom Templates

Create custom documentation templates:

**custom-template.myst:**
```html
<!DOCTYPE html>
<html>
<head>
  <title>{{project.name}} - {{project.version}}</title>
  <style>
    body { font-family: sans-serif; max-width: 800px; margin: 0 auto; }
    h1 { color: #4ade80; }
  </style>
</head>
<body>
  <h1>{{project.name}}</h1>
  <p>{{project.description}}</p>

  {{#if project.features}}
  <h2>Features</h2>
  <ul>
    {{#each project.features}}
    <li>{{this}}</li>
    {{/each}}
  </ul>
  {{/if}}

  <footer>
    Version {{project.version}} • License: {{project.license}}
  </footer>
</body>
</html>
```

**Usage:**
```bash
leaf . -o docs/ --template custom-template.myst
```

---

## Related Projects

Part of the [butter.sh](https://github.com/butter-sh) ecosystem:

- **[arty.sh](https://github.com/butter-sh/arty.sh)** — Dependency manager
- **[judge.sh](https://github.com/butter-sh/judge.sh)** — Testing framework
- **[myst.sh](https://github.com/butter-sh/myst.sh)** — Templating engine (powers leaf.sh)
- **[hammer.sh](https://github.com/butter-sh/hammer.sh)** — Project scaffolding
- **[whip.sh](https://github.com/butter-sh/whip.sh)** — Release management
- **[clean.sh](https://github.com/butter-sh/clean.sh)** — Linter and formatter

---

## License

MIT License — see [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

<div align="center">

**Part of the [butter.sh](https://github.com/butter-sh) ecosystem**

*Unlimited. Independent. Fresh.*

Crafted by [Valknar](https://github.com/valknarogg)

</div>
