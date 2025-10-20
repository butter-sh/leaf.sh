# CHANGELOG

## [2.0.0] - 2025-10-20

### Fixed
- **CRITICAL**: Fixed HTML escaping in code blocks that was breaking myst.sh templates
- Fixed ANSI color codes appearing in help text (changed `<<EOF` to `<<'EOF'`)
- Fixed "no output" issue when running without arguments
- Improved argument parsing to validate after parsing all args

### Added
- `escape_html()` function for proper HTML entity escaping
- `test-leaf.sh` automated test script
- `verify.sh` installation verification script
- Comprehensive documentation (README.md, IMPLEMENTATION.md, SUMMARY.md)
- Multiple usage examples in `examples/` directory
- Debug mode support with `--debug` flag
- Better error messages with color coding

### Changed
- Simplified script structure and removed unnecessary complexity
- Improved error handling throughout
- Better dependency checking with helpful install links
- Cleaner separation between documentation and landing page modes
- Updated templates with modern responsive design

### Templates
- Created `docs.html.myst` for documentation pages
- Created `landing.html.myst` for landing pages
- Added reusable partials:
  - `_head.myst` - HTML head section
  - `_header.myst` - Navigation header
  - `_footer.myst` - Footer
  - `_carbon_styles.myst` - Carbon theme CSS
  - `_common_scripts.myst` - JavaScript utilities

### Documentation
- Complete README.md with usage examples
- Technical IMPLEMENTATION.md document
- Project SUMMARY.md overview
- Example scripts for common use cases

## [1.0.0] - Original

### Issues
- HTML code in source files wasn't escaped properly
- ANSI color codes bleeding into help text
- Complex, hard-to-maintain codebase
- Limited documentation
- No automated testing

---

**Migration Notes:**

If you were using the original leaf.sh:

1. Update usage: `./leaf.sh` → `./leaf.sh .` (explicit directory)
2. HTML in code is now properly escaped automatically
3. Templates moved to dedicated `templates/` directory
4. New partials system for better reusability
5. Landing page mode now requires `--landing` flag

**Breaking Changes:**
- Argument parsing changed - must provide directory explicitly for docs mode
- Template structure reorganized - if you customized templates, update paths
