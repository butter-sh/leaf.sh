# Changelog

All notable changes to leaf.sh will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.2.0] - 2025-10-17

### Added
- **jq integration** for robust JSON parsing and validation
- `--projects-file` flag to load projects from a JSON file
- `parse_json()` function for JSON parsing with jq
- `validate_projects_json()` function for project JSON validation
- `read_json_file()` function for reading and validating JSON files
- JSON structure validation (array type, required fields)
- Enhanced debug output for JSON operations
- Example `projects.json` file in repository

### Changed
- **BREAKING**: Now requires `jq` to be installed alongside `yq`
- Updated `check_dependencies()` to verify both yq and jq
- Improved `generate_landing_page()` with priority: file > inline > default
- Enhanced error messages for JSON parsing failures
- Version bump to 2.2.0
- Updated banner to show "Powered by yq & jq parsers"

### Improved
- JSON parsing is now more reliable with professional-grade jq
- Better validation of project data structure
- More informative warnings for incomplete project data
- Debug mode shows detailed JSON parsing information
- Cleaner code with dedicated JSON handling functions

### Fixed
- Proper handling of malformed JSON with helpful error messages
- Better validation of required fields in project objects
- Improved error handling for missing JSON files

### Documentation
- Added comprehensive `JQ_INTEGRATION.md` guide
- Updated help text with `--projects-file` option
- Added JSON format documentation in help
- Updated `arty.yml` with jq dependency
- Added example `projects.json` file
- Documented migration path from v2.1.0

## [2.1.0] - 2025-10-17

### Added
- **yq integration** for robust YAML parsing instead of manual grep/sed parsing
- `check_dependencies()` function to verify yq is installed
- `--debug` flag for troubleshooting and verbose output
- `--version` flag to display version information
- `log_debug()` function for debug messages
- Enhanced language detection supporting 20+ languages (TypeScript, PHP, HTML, CSS, JSON, YAML, XML, SQL, Markdown)
- Support for `.png` icons in addition to SVG files
- Better error messages and user feedback
- Icon search priority system (checks multiple icon filenames)

### Changed
- **BREAKING**: Now requires `yq` to be installed
- Improved `show_usage()` help function with colored output and better formatting
- Enhanced `show_version()` function with detailed feature list
- Better project structure documentation in help text
- More descriptive log messages throughout the script
- Version bump to 2.1.0

### Improved
- YAML parsing is now more reliable and handles edge cases better
- Better file discovery with more detailed debug output
- Enhanced error handling for missing files and directories
- More informative warning messages when files are not found
- Cleaner code structure with better function organization

### Fixed
- Proper handling of YAML files with complex structures
- Better fallback behavior when arty.yml is missing or incomplete
- Improved icon detection logic with multiple fallback options

### Documentation
- Completely rewritten README.md with comprehensive examples
- Added "Prerequisites" section with yq installation instructions
- Added "Troubleshooting" section with common issues and solutions
- Added "Tips & Best Practices" section
- Added "Customization" section
- Added CI/CD integration examples
- Expanded "Command Line Options" table
- Added more usage examples
- Better structured sections for easier navigation
- New `CHANGELOG.md` file
- New `INSTALL.md` comprehensive installation guide
- New `UPDATE_SUMMARY.md` migration guide

## [2.0.0] - 2025-10-15

### Added
- Initial release of leaf.sh
- Documentation generation mode for arty.sh projects
- Landing page generation mode for butter.sh
- Modern design with Tailwind CSS
- Dark/light theme toggle with localStorage
- Syntax highlighting with Highlight.js
- Responsive mobile-first layout
- Animated floating icons
- Gradient text effects
- Custom logo support via `--logo` flag
- Base path configuration for subdirectory deployment
- Custom GitHub URL configuration
- Custom output directory support
- Project metadata parsing from arty.yml
- README.md rendering with Markdown support
- Automatic source file scanning
- Example file detection and display
- Carbon theme for landing pages
- Dual CTA buttons (primary gradient and secondary outline)
- Project card grid layout
- Mobile menu for landing pages
- Theme switcher with iconset.css integration

### Features

#### Documentation Mode
- Sticky navigation bar
- Hero section with animated icon
- Overview section with rendered README
- Source files section with syntax highlighting
- Examples section with code display
- Footer with ecosystem links
- Automatic language detection
- Support for multiple file types (.sh, .bash, .js, .py, .rb, .go, .rs, .java, .c, .cpp)

#### Landing Page Mode
- Carbon texture background
- Gradient CTAs
- Project cards with hover effects
- Responsive header with mobile menu
- Theme toggle
- GitHub integration
- Custom project list via JSON
- Light/dark mode support
- Animated fade-in effects

### Technical
- Single-file bash script
- No build process required
- CDN-based assets (Tailwind CSS, Highlight.js, Marked.js)
- Pure HTML/CSS/JavaScript output
- No server-side dependencies
- LocalStorage for theme persistence

---

## Release Notes

### Version 2.2.0 Highlights

This release adds robust JSON processing capabilities through `jq` integration. The major improvement is the ability to load projects from a JSON file, making it much easier to manage complex project lists for landing pages.

**Key improvements:**
- **Professional JSON Handling**: Uses `jq` for reliable parsing and validation
- **File Support**: New `--projects-file` flag for external JSON files
- **Validation**: Automatic validation of JSON structure and required fields
- **Better Errors**: Clear error messages for JSON issues
- **Debug Info**: Detailed JSON parsing information in debug mode

**Migration from 2.1.0:**
The only breaking change is the requirement for `jq`. Install it with:
```bash
# macOS
brew install jq

# Linux
sudo apt-get install jq  # Debian/Ubuntu
sudo dnf install jq      # Fedora/RHEL
sudo pacman -S jq        # Arch
```

All existing functionality remains the same. The `--projects` flag still works for inline JSON.

### Version 2.1.0 Highlights

The major improvement in this release is the integration of `yq` for YAML parsing. Previously, the script used a combination of `grep` and `sed` which was fragile and could fail with complex YAML structures. Now with `yq`, the parsing is robust and reliable.

**Key improvements:**
- **Reliability**: No more parsing errors with complex YAML files
- **Debugging**: New `--debug` flag helps troubleshoot issues quickly  
- **User Experience**: Better error messages and warnings
- **Documentation**: Comprehensive README with real-world examples
- **Language Support**: Extended syntax highlighting for more file types

**Migration from 2.0.0:**
The only breaking change is the requirement for `yq`. Install it with:
```bash
# macOS
brew install yq

# Linux
snap install yq
```

All command-line options remain the same, so existing scripts and workflows will continue to work once yq is installed.

---

## Future Roadmap

### Planned for 2.3.0
- [ ] Table of contents generation
- [ ] Search functionality
- [ ] Multiple theme options
- [ ] Custom CSS injection support
- [ ] Configuration file support (leaf.config.yml)
- [ ] Template system for customization

### Planned for 2.4.0
- [ ] PDF export functionality
- [ ] Version history/changelog integration
- [ ] Multi-language documentation support
- [ ] API documentation parsing
- [ ] Markdown extensions support

### Under Consideration
- [ ] Live preview mode with file watching
- [ ] Watch mode for automatic regeneration
- [ ] Plugin system for extensibility
- [ ] Custom template support
- [ ] Integration with popular documentation tools
- [ ] GraphQL API endpoint for dynamic content
- [ ] Webhook support for CI/CD
- [ ] Docker container for isolated generation

---

[2.2.0]: https://github.com/butter-sh/leaf.sh/compare/v2.1.0...v2.2.0
[2.1.0]: https://github.com/butter-sh/leaf.sh/compare/v2.0.0...v2.1.0
[2.0.0]: https://github.com/butter-sh/leaf.sh/releases/tag/v2.0.0
