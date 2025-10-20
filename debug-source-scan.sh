#!/usr/bin/env bash
# Debug source file scanning

cd ~/Projects/butter.sh/projects/whip.sh

echo "Debugging source file scanning for whip.sh..."
echo ""

echo "1. Checking what files exist:"
find . -type f -name "*.sh" | head -10
echo ""

echo "2. Testing the scan_source_files logic:"
PROJECT_DIR="."

# Replicate the scan logic
files=()
while IFS= read -r -d $'\0' file; do
    rel_path="${file#${PROJECT_DIR}/}"
    echo "Found: $file"
    echo "  Relative: $rel_path"
    
    if [[ "$rel_path" =~ ^(docs|examples|node_modules|\.git|\.)|\\.min\\. ]]; then
        echo "  ❌ EXCLUDED by pattern"
    else
        echo "  ✅ INCLUDED"
        files+=("$file")
    fi
    echo ""
done < <(find "$PROJECT_DIR" -type f \( -name "*.sh" -o -name "*.bash" \) -print0 2>/dev/null)

echo ""
echo "Total files found: ${#files[@]}"
echo ""
echo "Files that would be included:"
printf '%s\n' "${files[@]}"
