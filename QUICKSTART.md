# leaf.sh Quick Reference

## Documentation Mode

### Basic Commands
```bash
./leaf.sh                           # Generate docs for current directory
./leaf.sh /path/to/project          # Generate docs for specific project
./leaf.sh --logo ./icon.svg         # Use custom logo
./leaf.sh --base-path /docs/        # Set base path
./leaf.sh -o ./output               # Custom output directory
```

### Common Patterns
```bash
# Local development
./leaf.sh && open docs/index.html

# GitHub Pages deployment
./leaf.sh --base-path /my-repo/ -o docs

# Custom branding
./leaf.sh --logo ./brand/icon.svg --github https://github.com/my-org
```

## Landing Page Mode

### Basic Commands
```bash
./leaf.sh --landing                              # Generate landing page
./leaf.sh --landing --github https://github.com/org  # Custom GitHub
./leaf.sh --landing --logo ./brand.svg           # Custom logo
./leaf.sh --landing --base-path /                # Set base path
```

### Projects Configuration
```bash
# With custom projects
./leaf.sh --landing --projects '[
  {"url":"https://project1.com","label":"Project 1","desc":"Description","class":"card-project"},
  {"url":"https://project2.com","label":"Project 2","desc":"Description","class":"card-project"}
]'
```

### Complete Setup
```bash
./leaf.sh --landing \
  --logo ./butter.sh/_assets/brand/cube-carbon-light.svg \
  --github https://github.com/butter-sh \
  --base-path / \
  -o ./public
```

## Options Reference

| Option | Mode | Description | Default |
|--------|------|-------------|---------|
| `--landing` | Both | Switch to landing page mode | Documentation mode |
| `--logo PATH` | Both | Custom logo/icon file | Auto-detect |
| `--base-path PATH` | Both | HTML base path | `/` |
| `--github URL` | Both | GitHub organization URL | `https://github.com/butter-sh` |
| `--projects JSON` | Landing | Projects array | Default butter.sh projects |
| `-o, --output DIR` | Both | Output directory | `docs/` |
| `-h, --help` | Both | Show help message | - |

## Project JSON Structure

```json
{
  "url": "https://example.com",
  "label": "project.sh",
  "desc": "Short description of the project",
  "class": "card-project"
}
```

## Theme Colors

### Primary Colors
- **Light Green**: `#86efac` (RGB: 134, 239, 172)
- **Dim Green**: `#4ade80` (RGB: 74, 222, 128)

### Background Colors (Dark Mode)
- **Carbon Background**: `#1a1a1a` → `#2c3e50` gradient
- **Surface**: `#2c3e50`

### Background Colors (Light Mode)
- **Light Background**: `#f0f4f8` → `#e2e8f0` gradient
- **Surface**: `#ffffff`

## File Structure Requirements

### For Documentation Mode
```
project/
├── arty.yml              # Required: Project metadata
├── README.md             # Recommended: Overview content
├── LICENSE               # Optional: License info
├── *.sh, *.js, *.py      # Source files (auto-detected)
├── _assets/
│   └── icon/
│       └── icon.svg      # Optional: Project icon
└── examples/
    └── *.sh              # Optional: Example files
```

### For Landing Page Mode
```
project/
└── _assets/
    └── brand/
        └── logo.svg      # Optional: Custom logo
```

## Iconset.css Classes

Available icons from butter.sh iconset:
- `icon-github` - GitHub logo
- `icon-moon` - Dark mode toggle
- `icon-sun` - Light mode toggle
- `icon-cube` - Package/project icon
- `icon-code` - Code/development icon
- `icon-link` - External link icon
- `icon-leaf` - Leaf/nature icon
- And many more...

### Usage
```html
<i class="icon icon-github"></i>
<i class="icon icon-moon icon-lg"></i>
<i class="icon icon-sun icon-2xl"></i>
```

### Size Variants
- Default: `1em`
- `icon-xs`: `0.75em`
- `icon-sm`: `0.875em`
- `icon-lg`: `1.25em`
- `icon-xl`: `1.5em`
- `icon-2xl`: `2em`
- `icon-3xl`: `3em`

## Deployment Patterns

### Static Hosting
```bash
# Generate
./leaf.sh -o ./public

# Deploy to server
rsync -avz ./public/ user@server:/var/www/html/
```

### GitHub Pages
```bash
# Generate with correct base path
./leaf.sh --base-path /repository-name/ -o docs

# Commit and push
git add docs/
git commit -m "Update docs"
git push origin main

# Enable GitHub Pages in repository settings
# Source: docs/ folder
```

### Netlify/Vercel
```bash
# Generate to public directory
./leaf.sh -o public

# Deploy
netlify deploy --prod --dir=public
# or
vercel --prod
```

### CI/CD Integration
```yaml
# .github/workflows/docs.yml
name: Documentation
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Generate Docs
        run: |
          chmod +x ./leaf.sh
          ./leaf.sh --base-path /${{ github.event.repository.name }}/ -o docs
      - name: Deploy
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./docs
```

## Troubleshooting

### Issue: Icon not displaying
**Solution**: Ensure icon is SVG format and path is correct
```bash
# Check icon exists
ls -la _assets/icon/icon.svg

# Use custom logo
./leaf.sh --logo /full/path/to/icon.svg
```

### Issue: Base path not working
**Solution**: Ensure base path starts and ends with `/`
```bash
# Correct
./leaf.sh --base-path /my-project/

# Incorrect
./leaf.sh --base-path my-project
./leaf.sh --base-path /my-project
```

### Issue: Projects JSON not parsing
**Solution**: Validate JSON syntax
```bash
# Use a JSON validator
echo '[{"url":"..."}]' | jq .

# Escape properly in shell
./leaf.sh --landing --projects "$(cat projects.json)"
```

### Issue: Theme toggle not working
**Solution**: Check browser console for JavaScript errors
```bash
# Test in different browsers
# Check localStorage is enabled
# Verify CDN scripts loaded
```

## Performance Tips

1. **Optimize images**: Use SVG for logos (vector, scalable)
2. **CDN reliability**: Scripts load from CDN (fast, cached)
3. **Single file**: Output is one HTML file (portable)
4. **Minimal JS**: Only theme toggle and project injection
5. **CSS framework**: Tailwind provides optimal file size

## Accessibility

- Semantic HTML5 structure
- ARIA labels where needed
- Keyboard navigation support
- High contrast ratios
- Responsive design for all devices
- Screen reader friendly

## Browser Support

- Chrome/Edge: Full support
- Firefox: Full support
- Safari: Full support
- Mobile browsers: Full support
- IE11: Not supported (uses modern CSS/JS)

## Examples

### Multi-Project Documentation
```bash
# Generate docs for multiple projects
for project in project1 project2 project3; do
  ./leaf.sh "../$project" -o "docs/$project"
done
```

### Custom Theme Colors
Edit the generated HTML file:
```css
:root {
    --carbon-light: #YOUR_COLOR;
    --carbon-light-dim: #YOUR_COLOR_DIM;
}
```

### Add Custom Sections
Modify generated HTML to add sections:
```html
<section id="custom" class="py-16 px-4">
    <div class="max-w-7xl mx-auto">
        <!-- Your custom content -->
    </div>
</section>
```

## Best Practices

1. **Version your docs**: Include version in arty.yml
2. **Keep README updated**: It becomes your Overview section
3. **Write good examples**: They help users understand usage
4. **Test both themes**: Ensure readability in dark and light
5. **Use descriptive names**: For better navigation
6. **Keep projects short**: 3-6 projects on landing page
7. **Optimize for mobile**: Test on actual devices
8. **Link to GitHub**: Include GitHub links for contributions

## Advanced Usage

### Custom Favicon
Add to generated HTML `<head>`:
```html
<link rel="icon" type="image/svg+xml" href="/favicon.svg">
```

### Analytics Integration
Add before `</body>`:
```html
<script async src="https://www.googletagmanager.com/gtag/js?id=GA_ID"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'GA_ID');
</script>
```

### SEO Optimization
Add to `<head>`:
```html
<meta property="og:title" content="Your Title">
<meta property="og:description" content="Description">
<meta property="og:image" content="/preview.png">
<meta name="twitter:card" content="summary_large_image">
```

## Support

For issues or questions:
- GitHub: https://github.com/butter-sh
- Documentation: Run `./leaf.sh --help`
- Examples: See `examples/leaf-usage.sh`

---

**Version**: 2.0.0  
**Last Updated**: 2025  
**License**: MIT
