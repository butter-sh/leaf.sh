#!/usr/bin/env python3
# Fix the scan_source_files function in leaf.sh

import re

# Read the file
with open('/home/valknar/Projects/butter.sh/projects/leaf.sh/leaf.sh', 'r') as f:
    content = f.read()

# Old pattern to find
old_pattern = r'''# Scan source files
scan_source_files\(\) \{
  local files=\(\)
  
  while IFS= read -r -d \$'\\0' file; do
    local rel_path="\$\{file#\$\{PROJECT_DIR\}/\}"
    if \[\[ "\$rel_path" =~ \^\(docs\|examples\|node_modules\|\\.git\|\.\)\|\\.min\\. \]\]; then
      continue
    fi
    files+=\("\$file"\)
  done < <\(find "\$PROJECT_DIR" -type f \\( -name "\*\.sh" -o -name "\*\.bash" -o -name "\*\.js" -o -name "\*\.py" \\) -print0 2>/dev/null \|\| true\)
  
  printf '%s\\n' "\$\{files\[@\]\}"
\}'''

# New replacement
new_code = '''# Scan source files
scan_source_files() {
  local files=()
  
  while IFS= read -r -d $'\\0' file; do
    local rel_path="${file#${PROJECT_DIR}/}"
    local basename_file=$(basename "$rel_path")
    
    # Skip if: path starts with excluded dirs, contains .min., or basename starts with .
    if [[ "$rel_path" =~ ^(docs|examples|node_modules|__tests|\\.git)/ ]] || \\
       [[ "$rel_path" =~ \\.min\\. ]] || \\
       [[ "$basename_file" =~ ^\\. ]]; then
      continue
    fi
    
    files+=("$file")
  done < <(find "$PROJECT_DIR" -type f \\( -name "*.sh" -o -name "*.bash" -o -name "*.js" -o -name "*.py" \\) -print0 2>/dev/null || true)
  
  printf '%s\\n' "${files[@]}"
}'''

# Replace
content = re.sub(old_pattern, new_code, content)

# Write back
with open('/home/valknar/Projects/butter.sh/projects/leaf.sh/leaf.sh', 'w') as f:
    f.write(content)

print("✅ Fixed scan_source_files function in leaf.sh")
