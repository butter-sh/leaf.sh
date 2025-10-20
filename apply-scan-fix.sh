#!/usr/bin/env bash
# Fix the scan_source_files regex in leaf.sh

cd ~/Projects/butter.sh/projects/leaf.sh

echo "Fixing scan_source_files function..."

# Create a backup
cp leaf.sh leaf.sh.backup

# Replace the problematic line
# Old: if [[ "$rel_path" =~ ^(docs|examples|node_modules|\.git|\.)|\\.min\\. ]]; then
# New: Split into multiple conditions for clarity

sed -i '387s/.*/    local basename_file=$(basename "$rel_path")\n    # Skip if: path starts with excluded dirs, contains .min., or basename starts with .\n    if [[ "$rel_path" =~ ^(docs|examples|node_modules|__tests|\\.git)\/ ]] || [[ "$rel_path" =~ \\.min\\. ]] || [[ "$basename_file" =~ ^\\. ]]; then/' leaf.sh

echo "Done! Testing..."
bash leaf.sh ~/Projects/butter.sh/projects/whip.sh -o /tmp/test-scan-fix

echo ""
echo "Check the output:"
echo "grep 'Found.*source files' output should show 1 or more files"
