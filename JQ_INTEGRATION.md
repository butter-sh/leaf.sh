# leaf.sh v2.2.0 - jq Integration Update

## Overview

leaf.sh has been updated to version **2.2.0** with comprehensive `jq` integration for robust JSON handling, especially useful for landing page generation.

## 🎯 Key New Features

### 1. **jq Integration for JSON Processing**

- Added `jq` as a required dependency alongside `yq`
- Robust JSON parsing and validation
- Better error handling for malformed JSON
- Supports both inline JSON and JSON files

### 2. **New --projects-file Flag**

```bash
# Load projects from a JSON file
./leaf.sh --landing --projects-file ./projects.json
```

This makes it easier to manage complex project lists without dealing with command-line escaping.

### 3. **JSON Validation**

The script now validates:
- JSON syntax correctness
- Array structure for projects
- Required fields (url, label) for each project
- Provides helpful error messages

### 4. **Enhanced Debug Output**

Debug mode now shows:
- JSON parsing steps
- Validation results
- Project count and details
- File loading status

---

*[Content continues with full JQ_INTEGRATION.md...]*

For the complete content, see the full file that was just written to the template directory.

---

**Version**: 2.2.0  
**Release Date**: October 17, 2025  
**License**: MIT  
**Author**: butter.sh team
