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

leaf.sh is a documentation generator that creates beautiful, responsive HTML documentation websites and landing pages. Built as a streamlined CLI wrapper around hammer.sh, it provides template-based documentation generation with seamless integration into the butter.sh ecosystem.

### Key Features

- **Template-Based Architecture** — Powered by hammer.sh for extensible templating
- **Responsive Design** — Mobile-first, modern documentation layout
- **Project Documentation** — Generate docs from arty.yml metadata
- **Landing Pages** — Create ecosystem overview pages from projects.json
- **Easy Extensibility** — Add new templates effortlessly
- **Batch & Interactive Modes** — Use `--yes` flag or interactive prompts

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
- **hammer.sh** for template generation (includes myst.sh)

---

## Usage

leaf.sh uses a **template-as-subcommand** architecture. Available templates: `docs`, `landing` (more coming soon).

### Generate Project Documentation

```bash
# Interactive mode
leaf docs -o ./docs

# Batch mode with icon
leaf docs -o ./docs \
  --icon ./icon.svg \
  --github-url "https://github.com/user/repo" \
  --yes

# Minimal with defaults (reads from arty.yml)
leaf docs -o ./docs --icon ./icon.svg --yes
```

### Generate Landing Page

```bash
# Interactive mode
leaf landing -o ./index.html

# Batch mode with logo
leaf landing -o ./index.html \
  --logo ./logo.svg \
  --github-url "https://github.com/butter-sh" \
  --base-url "https://butter-sh.github.io" \
  --yes

# Minimal (reads from arty.yml)
leaf landing -o ./index.html --logo ./logo.svg --yes
```

### Common Options

```bash
-o, --output PATH     Output file or directory (required)
--yes                 Skip interactive prompts, use defaults
--force               Overwrite existing files without confirmation
-h, --help            Show help message
```

### Template-Specific Options

**docs template:**
- `--github-url URL` — GitHub repository URL
- `--base-path PATH` — Base path for links (default: `/`)
- `--icon PATH` — Path to icon SVG file
- `--logo PATH` — Path to logo SVG file

**landing template:**
- `--github-url URL` — GitHub URL for organization/project
- `--base-url URL` — Base URL for project links
- `--logo PATH` — Path to logo SVG file

**Note:** leaf.sh automatically reads `name`, `version`, `description`, `author`, and `license` from `arty.yml` in the current working directory.

---

## Documentation Mode

The `docs` template generates project documentation pages. It automatically reads metadata from `arty.yml` in the current directory:

```bash
leaf docs -o ./docs --icon ./icon.svg --yes
```

**Reads from arty.yml:**
```yaml
name: "my-project"
version: "1.0.0"
description: "A professional bash library"
author: "Your Name"
license: "MIT"
```

**Generates:**
```
docs/
├── index.html        # Responsive documentation page
├── carbon.css        # Carbon theme stylesheet
├── icon.svg          # Project icon
├── README.md         # Project README
└── source/           # Source files
    └── *.sh
```

---

## Landing Page Mode

The `landing` template generates ecosystem overview pages with project grids. It reads project data from `arty.yml` or a separate projects configuration:

```bash
leaf landing -o ./index.html --logo ./logo.svg --yes
```

**arty.yml configuration:**
```yaml
name: "butter.sh"
version: "1.0.0"
description: "Professional Bash Development Ecosystem"

leaf:
  landing:
    projects:
      - label: "arty.sh"
        desc: "Dependency manager for bash libraries"
        url: "https://butter-sh.github.io/arty.sh"
        tagline: "Bash dependency manager"
      - label: "judge.sh"
        desc: "Professional testing framework"
        url: "https://butter-sh.github.io/judge.sh"
        tagline: "Bash testing framework"
```

**Generates:**
- Responsive landing page with project grid
- Carbon theme with smooth scrolling
- Large logo presentation
- Mobile-first design

---

## Examples

### Example 1: Quick Start

```bash
# Install dependencies
arty deps

# Generate docs for current project
leaf docs -o ./docs --icon ./icon.svg --yes

# Open in browser
open docs/index.html
```

### Example 2: Multi-Project Documentation

```bash
# Generate docs for all projects
for project in projects/*/; do
  cd "$project"
  leaf docs -o "../../docs/$(basename "$PWD")" \
    --icon ./icon.svg \
    --yes
  cd ../..
done

# Generate landing page
leaf landing -o docs/index.html \
  --logo ./logo.svg \
  --github-url "https://github.com/butter-sh" \
  --yes
```

### Example 3: Custom Branding

```bash
# Generate docs with custom icon and GitHub link
leaf docs -o ./docs \
  --icon ./custom-icon.svg \
  --github-url "https://github.com/user/myproject" \
  --yes

# Generate landing with logo
leaf landing -o ./index.html \
  --logo ./custom-logo.svg \
  --github-url "https://github.com/myorg" \
  --yes
```

### Example 4: CI/CD Integration

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
          sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
          sudo chmod +x /usr/local/bin/yq
      - name: Install arty.sh
        run: |
          git clone https://github.com/butter-sh/arty.sh.git
          cd arty.sh && sudo make install
      - name: Install leaf.sh
        run: arty install https://github.com/butter-sh/leaf.sh.git
      - name: Generate documentation
        run: arty exec leaf docs -o docs/ --icon ./icon.svg --yes
      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./docs
```

---

## Integration with arty.sh

Add leaf.sh to your project's `arty.yml`:

```yaml
name: "my-project"
version: "1.0.0"

references:
  - https://github.com/butter-sh/leaf.sh.git

scripts:
  docs: "arty exec leaf docs -o docs/ --icon ./icon.svg --yes"
  landing: "arty exec leaf landing -o index.html --logo ./logo.svg --yes"
```

**Usage:**

```bash
arty deps       # Install leaf.sh (and its dependencies)
arty docs       # Generate documentation
arty landing    # Generate landing page
```

---

## Adding Custom Templates

leaf.sh is designed for easy template extensibility. Create new templates in the `templates/` directory:

**Directory Structure:**
```
templates/
└── mytemplate/
    ├── template.yml        # Template configuration
    └── index.html.myst     # Myst template file
```

**template.yml:**
```yaml
name: "mytemplate"
description: "My custom template"
variables:
  - name: title
    prompt: "Title:"
    default: "My Page"
  - name: content
    prompt: "Content:"
    default: "Hello World"
```

**index.html.myst:**
```html
<!DOCTYPE html>
<html lang="en">
<head>
  <title>{{title}}</title>
  <style>
    body { font-family: sans-serif; max-width: 800px; margin: 0 auto; }
    h1 { color: #4ade80; }
  </style>
</head>
<body>
  <h1>{{title}}</h1>
  <p>{{content}}</p>
</body>
</html>
```

**Usage:**
```bash
leaf mytemplate -o ./output.html --title "Custom Page" --content "My content" --yes
```

Templates use [myst.sh](https://github.com/butter-sh/myst.sh) syntax for variables, conditionals, loops, and partials.

---

## Related Projects

Part of the [butter.sh](https://github.com/butter-sh) ecosystem:

- **[hammer.sh](https://github.com/butter-sh/hammer.sh)** — Project scaffolding (powers leaf.sh)
- **[myst.sh](https://github.com/butter-sh/myst.sh)** — Mustache templating engine
- **[arty.sh](https://github.com/butter-sh/arty.sh)** — Dependency manager
- **[judge.sh](https://github.com/butter-sh/judge.sh)** — Testing framework
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
