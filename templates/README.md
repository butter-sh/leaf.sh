# Leaf.sh Myst Templates

This directory contains myst.sh templates for generating beautiful documentation and landing pages with the butter.sh carbon theme.

## Directory Structure

```
templates/
├── partials/              # Shared partial templates
│   ├── _head.myst        # Common HTML head
│   ├── _carbon_styles.myst  # Carbon theme styles
│   ├── _header.myst      # Site header with navigation
│   ├── _footer.myst      # Site footer
│   └── _common_scripts.myst # Common JavaScript
├── landing.html.myst     # Landing page template
├── docs.html.myst        # Documentation page template
└── project.html.myst     # Project page template

## Templates Overview

### landing.html.myst
Landing page template with carbon theme for showcasing multiple projects (like butter.sh homepage).

**Required Variables:**
- `page_title` - Page title for SEO
- `page_description` - Page description
- `base_path` - Base path for links
- `site_name` - Site name (e.g., "butter.sh")
- `logo` - SVG logo markup
- `hero_tagline` - Hero section tagline
- `primary_cta_text` / `primary_cta_url` - Primary CTA button
- `secondary_cta_text` / `secondary_cta_url` - Secondary CTA button
- `projects_section_title` - Title for projects section
- `projects_json` - JSON array of projects
- `github_url` - GitHub organization URL
- `footer_tagline` - Footer tagline
- `default_theme` - Default theme (dark/light)

**Optional Variables:**
- `nav_items` - Array of navigation items
- `generator_credit` - Show generator credit (true/false)
- `myst_enabled` - Show myst.sh credit (true/false)

### docs.html.myst
Documentation page template for arty.sh projects with syntax highlighting.

**Required Variables:**
- `page_title`, `page_description`, `base_path` - Basic page info
- `project_name` - Project name
- `project_version` - Version number
- `project_description` - Short description
- `icon` - Project icon SVG markup
- `readme_content` - README content (HTML)
- `source_files_html` - Source files HTML
- `examples_html` - Examples HTML
- `github_url` - GitHub URL

**Optional Variables:**
- `myst_enabled` - Show myst.sh credit

### project.html.myst
Individual project page with carbon theme, features, installation, and usage.

**Required Variables:**
- `page_title`, `page_description`, `base_path` - Basic page info
- `site_name` - Site name for header
- `logo` - Site logo
- `project_icon` - Project-specific icon
- `project_name` - Project name
- `project_tagline` - Short tagline
- `install_url`, `docs_url`, `github_url` - Action URLs
- `install_command` - Installation command
- `nav_items` - Navigation items

**Optional Variables:**
- `project_version` - Version number
- `project_license` - License type
- `stars_count` - GitHub stars
- `contributors_count` - Number of contributors
- `features` - Array of feature descriptions
- `install_steps` - Array of installation steps
- `usage_example` - Usage code example
- `related_projects` - Array of related project objects
- `footer_tagline` - Footer tagline
- `default_theme` - Default theme

## Partials

### _head.myst
Common HTML head section with meta tags and Tailwind CSS.

### _carbon_styles.myst
Complete carbon theme styling with:
- Carbon texture background
- Gradient CTA buttons
- Project cards with hover effects
- Light/dark mode support
- Mobile menu styles
- Fade-in animations

### _header.myst
Responsive header with:
- Logo and site name
- Navigation menu
- GitHub link
- Theme toggle
- Mobile menu

### _footer.myst
Footer with:
- Site branding
- Tagline
- GitHub link
- Generator credits (optional)

### _common_scripts.myst
Common JavaScript for:
- Theme toggle with localStorage
- Mobile menu toggle

## Usage with Myst.sh

### Basic Rendering

```bash
# Render landing page
myst.sh render templates/landing.html.myst \
  -p templates/partials \
  -j landing-data.json \
  -o dist/index.html

# Render docs page
myst.sh render templates/docs.html.myst \
  -p templates/partials \
  -j docs-data.json \
  -o dist/docs.html

# Render project page
myst.sh render templates/project.html.myst \
  -p templates/partials \
  -j project-data.json \
  -o dist/project.html
```

### Example Data Files

**landing-data.json:**
```json
{
  "page_title": "butter.sh - Modern Bash Development",
  "page_description": "A collection of modern bash tools",
  "base_path": "/",
  "site_name": "butter.sh",
  "logo": "<svg>...</svg>",
  "hero_tagline": "Modern bash development tools",
  "primary_cta_text": "Explore Projects",
  "primary_cta_url": "#projects",
  "secondary_cta_text": "Learn More",
  "secondary_cta_url": "#about",
  "projects_section_title": "Our Projects",
  "projects_json": "[...]",
  "github_url": "https://github.com/butter-sh",
  "footer_tagline": "Building the future of bash",
  "default_theme": "dark",
  "nav_items": "#projects,#about",
  "generator_credit": "true",
  "myst_enabled": "true"
}
```

**project-data.json:**
```json
{
  "page_title": "hammer.sh - Project Generator",
  "page_description": "Bash project generator",
  "base_path": "/",
  "site_name": "butter.sh",
  "logo": "<svg>...</svg>",
  "project_icon": "<svg>...</svg>",
  "project_name": "hammer.sh",
  "project_tagline": "Generate bash projects with ease",
  "project_version": "1.0.0",
  "project_license": "MIT",
  "install_url": "#installation",
  "docs_url": "/docs",
  "github_url": "https://github.com/butter-sh/hammer.sh",
  "install_command": "git clone https://github.com/butter-sh/hammer.sh",
  "features": "Fast,Simple,Extensible",
  "usage_example": "bash hammer.sh arty my-project",
  "nav_items": "#features,#installation",
  "default_theme": "dark"
}
```

## Integration with leaf.sh

The leaf.sh script can check for myst.sh availability and use these templates:

```bash
# In leaf.sh
if command -v myst >/dev/null 2>&1 && [[ -f "templates/landing.html.myst" ]]; then
  # Use myst for rendering
  myst render templates/landing.html.myst \
    -p templates/partials \
    -v site_name="butter.sh" \
    -v ... \
    -o dist/index.html
else
  # Fall back to bash generation
  generate_landing_page_bash
fi
```

## Customization

### Adding New Partials

1. Create new partial in `templates/partials/_name.myst`
2. Include it in templates with `{{> _name}}`

### Custom Styles

Add custom styles to `_carbon_styles.myst` or create a new partial:

```myst
{{> _carbon_styles}}
<style>
  /* Custom styles */
</style>
```

### Extending Templates

Create new templates based on existing ones:

```bash
cp templates/project.html.myst templates/custom.html.myst
# Edit custom.html.myst
```

## Corporate Identity Guidelines

All templates follow the butter.sh carbon theme:

**Colors:**
- Primary: `#86efac` (carbon-light)
- Secondary: `#4ade80` (carbon-light-dim)
- Background: `#1a1a1a` (carbon-bg)
- Surface: `#2c3e50` (carbon-surface)

**Typography:**
- Font: Inter
- Headings: Bold, using carbon-light color
- Body: Regular weight, slate-300

**Components:**
- Cards: Semi-transparent with border and backdrop blur
- Buttons: Gradient (primary) or bordered (secondary)
- Hover effects: Transform + shadow
- Animations: Fade-in with stagger

## Best Practices

1. **Always use partials** for shared components
2. **Keep templates DRY** - extract reusable patterns
3. **Use semantic variable names** - clear and descriptive
4. **Test both themes** - ensure light/dark mode compatibility
5. **Validate JSON** - use jq to validate data files
6. **Mobile-first** - ensure responsive design
7. **Accessibility** - use semantic HTML and proper contrast

## Troubleshooting

### Partial not found
Ensure you specify the partials directory:
```bash
myst.sh render template.myst -p templates/partials
```

### Variables not rendering
Check variable names match exactly (case-sensitive):
```bash
# Debug mode
MYST_DEBUG=1 myst.sh render template.myst -v var=value
```

### Styling issues
Verify `_carbon_styles.myst` is included:
```mustache
{{> _carbon_styles}}
```

## Resources

- [myst.sh Documentation](../../myst/README.md)
- [Myst DSL Reference](../../myst/DSL_DOCUMENTATION.md)
- [Myst API Reference](../../myst/API_REFERENCE.md)
- [butter.sh Brand Guidelines](https://butter.sh/brand)

---

**Built with ❤️ using myst.sh + leaf.sh**
