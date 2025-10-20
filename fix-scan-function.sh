#!/usr/bin/env bash
# Manual fix for scan_source_files function

cd ~/Projects/butter.sh/projects/leaf.sh

# Restore from backup if it exists
if [ -f leaf.sh.bak ]; then
    echo "Restoring from backup..."
    cp leaf.sh.bak leaf.sh
fi

# Create a proper backup
cp leaf.sh leaf.sh.backup

echo "Fixing scan_source_files function..."

# Use awk to replace just the scan_source_files function
awk '
/^# Scan source files$/ {
    print
    print "scan_source_files() {"
    print "  local files=()"
    print "  "
    print "  while IFS= read -r -d $'"'"'\\0'"'"' file; do"
    print "    local rel_path=\"${file#${PROJECT_DIR}/}\""
    print "    local basename_file=$(basename \"$rel_path\")"
    print "    "
    print "    # Skip if: path starts with excluded dirs, contains .min., or basename starts with ."
    print "    if [[ \"$rel_path\" =~ ^(docs|examples|node_modules|__tests|\\.git)/ ]] || \\"
    print "       [[ \"$rel_path\" =~ \\.min\\. ]] || \\"
    print "       [[ \"$basename_file\" =~ ^\\. ]]; then"
    print "      continue"
    print "    fi"
    print "    "
    print "    files+=(\"$file\")"
    print "  done < <(find \"$PROJECT_DIR\" -type f \\( -name \"*.sh\" -o -name \"*.bash\" -o -name \"*.js\" -o -name \"*.py\" \\) -print0 2>/dev/null || true)"
    print "  "
    print "  printf '"'"'%s\\n'"'"' \"${files[@]}\""
    print "}"
    # Skip the old function definition
    skip = 1
    next
}

skip && /^}$/ {
    skip = 0
    next
}

!skip {
    print
}
' leaf.sh.backup > leaf.sh.tmp

# Check if the new file is valid
if bash -n leaf.sh.tmp 2>/dev/null; then
    mv leaf.sh.tmp leaf.sh
    echo "✅ Fixed successfully!"
    echo ""
    echo "Testing..."
    cd ~/Projects/butter.sh/projects/whip.sh
    bash ../leaf.sh/leaf.sh . -o /tmp/test-scan-final 2>&1 | grep "Found.*source"
else
    echo "❌ Syntax error in generated file"
    cat leaf.sh.tmp
    rm leaf.sh.tmp
    exit 1
fi
