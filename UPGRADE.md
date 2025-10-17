# Upgrading to leaf.sh v2.0

## What's New

leaf.sh v2.0 is a major update that adds landing page generation while maintaining full backward compatibility with v1.0 documentation generation.

### Major Changes

1. **Dual Mode Operation**: Now supports both documentation and landing page generation
2. **Enhanced CLI**: New command-line options for customization
3. **butter.sh Integration**: Native support for butter.sh landing pages
4. **Theme Improvements**: Better dark/light mode with fade transitions
5. **Icon System**: Integration with butter.sh iconset.css

## Backward Compatibility

✅ **All v1.0 commands work exactly the same in v2.0**

Your existing scripts and workflows will continue to work without changes.

```bash
# v1.0 commands that still work in v2.0
./leaf.sh                      # Still generates documentation
./leaf.sh /path/to/project     # Still works
./leaf.sh --help               # Still shows help
```

## Migration Guide

### If You're Using Basic Documentation Generation

**No action required!** Your current usage continues to work.

### If You Want to Use New Features

#### 1. Add Custom Logo (New in v2.0)

**Before (v1.0):**
```bash
# Logo auto-detected from _assets/icon/
./leaf.sh
```

**After (v2.0):**
```bash
# Can now specify custom logo
./leaf.sh --logo /path/to/custom-logo.svg
```

#### 2. Set Base Path (New in v2.0)

**Before (v1.0):**
```bash
# Always used root path "/"
./leaf.sh
```

**After (v2.0):**
```bash
# Can configure base path for subdirectory deployment
./leaf.sh --base-path /my-project/
```

#### 3. Generate Landing Pages (New in v2.0)

**New Feature:**
```bash
# Generate butter.sh landing page
./leaf.sh --landing

# With custom projects
./leaf.sh --landing --projects '[...]'
```

## New Command-Line Options

### Documentation Mode (Enhanced)

```bash
# New options (v2.0)
--logo PATH          # Custom logo file
--base-path PATH     # HTML base path
--github URL         # GitHub organization URL
-o, --output DIR     # Output directory (already existed)
```

### Landing Page Mode (New)

```bash
# New mode (v2.0)
--landing            # Switch to landing page mode
--projects JSON      # Project list as JSON
--logo PATH          # Landing page logo
--base-path PATH     # HTML base path
--github URL         # GitHub link
```

## Updated File Structure

### v1.0 Structure (Still Supported)
```
project/
├── arty.yml
├── README.md
├── *.sh files
├── _assets/icon/icon.svg
└── examples/
```

### v2.0 Enhanced (Optional Additions)
```
project/
├── arty.yml
├── README.md
├── *.sh files
├── _assets/
│   ├── icon/icon.svg          # For documentation
│   ├── brand/logo.svg         # For landing page
│   └── styles/iconset.css     # For icons (optional)
└── examples/
```

## Breaking Changes

### None! 🎉

v2.0 is fully backward compatible. All v1.0 functionality is preserved.

## Deprecated Features

### None!

All v1.0 features are still supported and maintained.

## New Dependencies

### CDN Assets (Unchanged)
- Tailwind CSS v4 (same as v1.0)
- Highlight.js (same as v1.0)
- Marked.js (same as v1.0)

### New Optional Assets
- iconset.css (for landing pages, loaded from butter.sh)

All dependencies are CDN-based, no installation required.

## Configuration Changes

### arty.yml Format (Unchanged)

```yaml
# Same format as v1.0
name: "project-name"
version: "1.0.0"
description: "Description"
author: "Author"
license: "MIT"
main: "main.sh"
```

### New Options (Optional)

You can now customize more via command-line:

```bash
# Example with all new v2.0 options
./leaf.sh /path/to/project \
  --logo ./custom-icon.svg \
  --base-path /docs/ \
  --github https://github.com/my-org \
  -o ./public
```

## Upgrade Steps

### For Existing Projects

1. **No immediate action needed** - v2.0 works with existing projects
2. **Optional**: Add custom logo if desired
3. **Optional**: Set base-path for proper deployment
4. **Optional**: Try new landing page mode

### For New Projects

Generate with hammer.sh:

```bash
# v2.0 template
hammer.sh leaf my-new-docs
cd my-new-docs
chmod +x leaf.sh
```

## Feature Comparison

| Feature | v1.0 | v2.0 |
|---------|------|------|
| Documentation Generation | ✅ | ✅ |
| Syntax Highlighting | ✅ | ✅ |
| Dark/Light Theme | ✅ | ✅ Better |
| Custom Logo | ❌ | ✅ New |
| Base Path Config | ❌ | ✅ New |
| GitHub Link Config | ❌ | ✅ New |
| Landing Page Mode | ❌ | ✅ New |
| butter.sh Integration | ❌ | ✅ New |
| Icon System | ❌ | ✅ New |
| Project Cards | ❌ | ✅ New |
| Theme Switcher | Basic | ✅ Enhanced |

## Testing Your Upgrade

### Step 1: Test Documentation Mode

```bash
# Generate docs as usual
./leaf.sh

# Open and verify
open docs/index.html
```

### Step 2: Test New Options

```bash
# Try custom logo
./leaf.sh --logo ./test-logo.svg

# Try base-path
./leaf.sh --base-path /test/
```

### Step 3: Test Landing Mode

```bash
# Generate landing page
./leaf.sh --landing -o ./landing-test

# Open and verify
open landing-test/index.html
```

## Common Issues

### Issue: Old leaf.sh version

**Symptom**: New options not recognized

**Solution**: Update template
```bash
# Re-generate with hammer.sh
hammer.sh leaf my-updated-leaf -f
```

### Issue: Custom logo not showing

**Symptom**: Default icon displayed

**Solution**: Verify SVG path
```bash
# Check file exists
ls -la /path/to/logo.svg

# Use absolute path
./leaf.sh --logo $(pwd)/logo.svg
```

### Issue: Base path broken

**Symptom**: Links don't work

**Solution**: Ensure proper format
```bash
# Correct format (with slashes)
./leaf.sh --base-path /my-path/

# Incorrect formats
./leaf.sh --base-path my-path    # Missing slashes
./leaf.sh --base-path /my-path   # Missing trailing slash
```

## Rollback Instructions

If you need to rollback to v1.0:

```bash
# Check out v1.0 template from git
git checkout v1.0 -- templates/leaf/

# Or use old leaf.sh script
./leaf.sh-v1.0 [arguments]
```

**Note**: Rollback is not recommended as v2.0 is fully compatible.

## Getting Help

### Documentation
- README.md - Full documentation
- QUICKSTART.md - Quick reference
- FEATURES.md - Feature list
- This file - Migration guide

### Examples
```bash
# See usage examples
./examples/leaf-usage.sh
```

### Command Help
```bash
# Show help
./leaf.sh --help
```

### Support
- GitHub Issues: Report problems
- Community: Ask questions
- Documentation: Check guides

## Best Practices for v2.0

1. **Use --base-path** for GitHub Pages deployment
2. **Use --logo** for custom branding
3. **Test both themes** after generation
4. **Keep projects.json** in a file for landing pages
5. **Version your docs** with git
6. **Test mobile** responsiveness
7. **Validate HTML** output

## What's Next

Future versions may include:
- Multi-page documentation support
- Custom theme builder
- Interactive code examples
- PDF export
- Search functionality
- Plugin system

Stay tuned for updates!

## Feedback

We'd love to hear about your experience upgrading to v2.0:

- ⭐ Star the project on GitHub
- 🐛 Report issues
- 💡 Suggest features
- 🤝 Contribute improvements

## Summary

✅ **Fully backward compatible**  
✅ **New features available**  
✅ **No breaking changes**  
✅ **Easy migration**  
✅ **Enhanced functionality**

Upgrade with confidence! Your v1.0 workflows will continue to work while you explore new v2.0 features at your own pace.

---

**Version**: 2.0.0  
**Release Date**: 2025  
**License**: MIT  
**Organization**: butter.sh
