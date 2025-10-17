# leaf.sh - Feature Summary

## Version 2.0.0

### Major Features

#### I. Documentation Generator
A complete static documentation site generator for arty.sh projects.

**Core Capabilities:**
1. ✅ Automatic project scanning and file detection
2. ✅ Parses arty.yml for metadata
3. ✅ Converts README.md to HTML
4. ✅ Includes LICENSE information
5. ✅ Displays source files with syntax highlighting
6. ✅ Shows examples from examples/ directory
7. ✅ Auto-detects icon from _assets/icon/

**Visual Features:**
1. ✅ Modern responsive design with Tailwind CSS v4
2. ✅ Dark/Light theme toggle with localStorage
3. ✅ Syntax highlighting via Highlight.js
4. ✅ Smooth animations and transitions
5. ✅ Mobile-first responsive layout
6. ✅ Gradient hero section
7. ✅ Card-based file display
8. ✅ Sticky navigation header

**Customization Options:**
1. ✅ Configurable logo path via `--logo`
2. ✅ Configurable HTML base-path via `--base-path`
3. ✅ Configurable output directory via `-o`
4. ✅ Configurable GitHub link via `--github`

**Technical Stack:**
- Tailwind CSS v4 (styling)
- Highlight.js (syntax highlighting)
- Marked.js (markdown parsing)
- Inter font (UI)
- JetBrains Mono (code)

#### II. Landing Page Generator
A stylish landing page generator for butter.sh with carbon theme.

**Core Capabilities:**
1. ✅ Generates modern landing page
2. ✅ Takes project list as JSON argument
3. ✅ Integrates butter.sh branding
4. ✅ Uses iconset.css icon system
5. ✅ Configurable GitHub organization link

**Visual Features:**
1. ✅ Cool urban military carbon minimalistic theme
2. ✅ Carbon texture background pattern
3. ✅ Wide stylish hero section with gradient title
4. ✅ Primary gradient CTA button (light green gradient)
5. ✅ Secondary outline CTA button
6. ✅ Responsive header with logo and navigation
7. ✅ Mobile-friendly hamburger menu
8. ✅ Theme switcher with iconset.css icons
9. ✅ Smooth fade between dark/light modes
10. ✅ Project cards with hover effects

**Theme Specifications:**
- **Primary Color**: Light Green `#86efac` → `#4ade80`
- **Background**: Carbon gradient `#2c3e50` → `#1a1a1a`
- **Light Mode**: Faded theme with matching light colors `#f0f4f8` → `#e2e8f0`
- **Texture**: CSS pattern overlay for carbon effect

**Customization Options:**
1. ✅ Custom projects list via `--projects JSON`
2. ✅ Custom logo via `--logo`
3. ✅ Custom GitHub URL via `--github`
4. ✅ Custom base-path via `--base-path`
5. ✅ Custom output directory via `-o`

**Integration:**
- Uses butter.sh cube-carbon-light.svg as default logo
- Integrates iconset.css for consistent icons
- Links to butter.sh organization by default
- Supports custom project JSON structure

### Command Line Interface

**General Options:**
```bash
--landing              # Switch to landing page mode
--logo PATH            # Custom logo/icon file path
--base-path PATH       # HTML base path for links
--github URL           # GitHub organization URL
--projects JSON        # Projects array for landing page
-o, --output DIR       # Output directory
-h, --help             # Show help message
```

**Documentation Mode:**
```bash
./leaf.sh [project-dir] [options]
```

**Landing Page Mode:**
```bash
./leaf.sh --landing [options]
```

### Project Structure Integration

**Documentation Mode Requirements:**
```
project/
├── arty.yml           ← Parsed for metadata
├── README.md          ← Converted to Overview
├── LICENSE            ← Displayed in footer
├── *.sh, *.js, *.py   ← Auto-scanned source files
├── _assets/
│   └── icon/
│       └── icon.svg   ← Auto-detected icon
└── examples/
    └── *.sh           ← Example files with syntax highlighting
```

**Landing Page Requirements:**
```
Optional:
- Custom logo file (SVG recommended)
- iconset.css file (from butter.sh)
- Custom projects JSON
```

### File Generation

**Output Structure:**
```
docs/
└── index.html         # Self-contained HTML file
```

**Output Characteristics:**
- Single HTML file (portable)
- CDN-based assets (fast loading)
- No build process required
- Works offline after first load
- Can be deployed anywhere

### Browser Compatibility

- ✅ Chrome/Edge (latest)
- ✅ Firefox (latest)
- ✅ Safari (latest)
- ✅ Mobile browsers
- ❌ IE11 (not supported)

### Accessibility Features

- Semantic HTML5 structure
- ARIA labels where appropriate
- Keyboard navigation support
- High contrast ratios in both themes
- Responsive design for all screen sizes
- Screen reader compatible

### Performance Characteristics

- **Load Time**: Fast (CDN assets)
- **File Size**: Small (single HTML file)
- **Rendering**: Smooth (CSS animations)
- **Interactivity**: Instant (minimal JS)
- **Mobile**: Optimized (responsive design)

### Integration Points

**butter.sh Ecosystem:**
1. Links to butter.sh home page
2. Uses butter.sh brand assets
3. Integrates iconset.css icons
4. Follows butter.sh design language

**arty.sh Projects:**
1. Parses arty.yml metadata
2. Scans project structure
3. Generates documentation automatically
4. Preserves project information

**hammer.sh Generator:**
1. Template in hammer.sh/templates/leaf/
2. Generated via `hammer.sh leaf project-name`
3. Includes setup instructions
4. Part of project template system

### Use Cases

**Documentation Mode:**
1. Generate docs for bash libraries
2. Create project documentation sites
3. Build API references
4. Document CLI tools
5. Create tutorials and guides

**Landing Page Mode:**
1. Organization landing pages
2. Project portfolio sites
3. Product showcase pages
4. Developer tool hubs
5. Open source collections

### Deployment Targets

- GitHub Pages
- Netlify
- Vercel
- Static hosting (Apache, Nginx)
- CDN (CloudFlare, AWS S3)
- Docker containers
- CI/CD pipelines

### Extensibility

**Easy to Customize:**
- Edit generated HTML directly
- Add custom CSS styles
- Include additional JavaScript
- Integrate analytics
- Add custom sections
- Modify theme colors

**Template Modification:**
- Edit leaf.sh generator script
- Customize HTML templates
- Add new features
- Extend functionality

### Quality Assurance

**Validated Against:**
- HTML5 standards
- CSS3 specifications
- JavaScript ES6+
- Accessibility guidelines (WCAG)
- Mobile responsiveness
- Cross-browser compatibility

### Version History

**v2.0.0** (Current)
- Added landing page generation mode
- Implemented dual-mode functionality
- Added butter.sh theme support
- Integrated iconset.css
- Added theme switcher
- Added configurable options
- Improved documentation

**v1.0.0** (Previous)
- Initial documentation generator
- Basic theme support
- Syntax highlighting
- Markdown parsing

### Future Enhancements

**Potential Features:**
- PDF export functionality
- Search functionality
- Multi-language support
- Version history display
- Interactive code examples
- Live code editing
- Custom theme builder
- Plugin system

### Known Limitations

1. No localStorage support in artifacts (use in own environment)
2. Single HTML file only (no multi-page support)
3. CDN dependency (requires internet for first load)
4. No build-time optimization
5. Limited to provided icon set

### Support & Resources

**Documentation:**
- README.md - Full documentation
- QUICKSTART.md - Quick reference guide
- examples/leaf-usage.sh - Usage examples
- `--help` flag - Command line help

**Community:**
- GitHub: https://github.com/butter-sh
- Issues: Report bugs and request features
- Contributions: Pull requests welcome

---

**License**: MIT  
**Author**: hammer.sh generator  
**Organization**: butter.sh ecosystem  
**Version**: 2.0.0
