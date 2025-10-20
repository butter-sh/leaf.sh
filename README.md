# 🌿 leaf.sh

Beautiful documentation and landing page generator for arty.sh projects and butter.sh

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

```bash
# Clone or download leaf.sh
git clone https://github.com/butter-sh/leaf.sh.git

# Make executable
chmod +x leaf.sh

# Install dependencies (if using arty.sh)
arty deps
```

## Dependencies

- **yq** - YAML parser (required)
- **jq** - JSON processor (required)
- **myst.sh** - Templating engine (required)

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

## License

MIT License - See LICENSE file for details

## Author

valknar@pivoine.art

## Part of butter.sh Ecosystem

- **hammer.sh** - Configurable bash project generator
- **arty.sh** - Bash library repository manager
- **leaf.sh** - Beautiful documentation generator
- **whip.sh** - Release cycle management
- **judge.sh** - Testing framework
- **myst.sh** - Templating engine
