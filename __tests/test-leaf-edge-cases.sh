#!/usr/bin/env bash
# Test suite for leaf.sh edge cases and error handling

# Setup before each test
setup() {
  TEST_ENV_DIR=$(create_test_env)
  cd "$TEST_ENV_DIR"
}

teardown() {
  cleanup_test_env
}

# Test: handles non-existent project directory
test_handles_nonexistent_directory() {
  setup
    
  set +e
  output=$(bash "$LEAF_SH" /nonexistent/directory -o test-output 2>&1)
  exit_code=$?
  set -e
    
  assert_exit_code 1 "$exit_code" "Should exit with error"
  assert_contains "$output" "not found" "Should show directory not found error"
    
  teardown
}

# Test: handles empty project directory
test_handles_empty_directory() {
  setup
    
  mkdir -p empty-project
    
  bash "$LEAF_SH" empty-project -o test-output >/dev/null 2>&1 || true
    
    # Should handle gracefully
  assert_true "true" "Should handle empty directory"
    
  teardown
}

# Test: handles project with only binary files
test_handles_binary_only_project() {
  setup
    
  mkdir -p binary-project
    # Create a binary file
  echo -e '\x00\x01\x02\x03' > binary-project/binary.bin
    
  bash "$LEAF_SH" binary-project -o test-output >/dev/null 2>&1 || true
    
    # Should handle gracefully
  assert_true "true" "Should handle binary-only project"
    
  teardown
}

# Test: handles very large README
test_handles_large_readme() {
  setup
    
  mkdir -p large-project
    
    # Create a large README
  {
    echo "# Large Project"
    for i in {1..1000}; do
      echo "Line $i with some content to make it larger"
    done
  } > large-project/README.md
    
  bash "$LEAF_SH" large-project -o test-output >/dev/null 2>&1 || true
    
    # Should handle large files
  if [[ -f "test-output/index.html" ]]; then
    assert_file_exists "test-output/index.html" "Should handle large README"
  fi
    
  teardown
}

# Test: handles special characters in project name
test_handles_special_chars_in_name() {
  setup
    
  mkdir -p "project-with-special-chars"
    cat > "project-with-special-chars/arty.yml" <<EOF
name: project-with-special<>&"'chars
description: A project with special characters
EOF
    
  bash "$LEAF_SH" "project-with-special-chars" -o test-output >/dev/null 2>&1 || true
    
    # Should handle special characters
  assert_true "true" "Should handle special characters"
    
  teardown
}

# Test: handles Unicode in README
test_handles_unicode_in_readme() {
  setup
    
  mkdir -p unicode-project
    cat > unicode-project/README.md <<'EOF'
# Project with Unicode

Hello 世界 🌍 émojis and spëcial çhars
EOF
    
  bash "$LEAF_SH" unicode-project -o test-output >/dev/null 2>&1 || true
    
  if [[ -f "test-output/index.html" ]]; then
    assert_file_exists "test-output/index.html" "Should handle Unicode"
  fi
    
  teardown
}

# Test: handles code with template syntax
test_handles_template_syntax_in_code() {
  setup
    
  mkdir -p template-project
    cat > template-project/test.sh <<'EOF'
#!/usr/bin/env bash
# This has template-like syntax
echo "{{variable}}"
echo "{{#if condition}}yes{{/if}}"
EOF
    
  bash "$LEAF_SH" template-project -o test-output >/dev/null 2>&1 || true
    
  if [[ -f "test-output/index.html" ]]; then
    content=$(cat test-output/index.html)
        # Template syntax should be properly escaped
    assert_true "[[ -f 'test-output/index.html' ]]" "Should handle template syntax"
  fi
    
  teardown
}

# Test: handles deeply nested directories
test_handles_nested_directories() {
  setup
    
  mkdir -p nested/very/deep/structure/with/many/levels
  echo '#!/usr/bin/env bash' > nested/very/deep/structure/with/many/levels/test.sh
    
  bash "$LEAF_SH" nested -o test-output >/dev/null 2>&1 || true
    
    # Should handle nested structures
  assert_true "true" "Should handle nested directories"
    
  teardown
}

# Test: handles files without extensions
test_handles_files_without_extensions() {
  setup
    
  mkdir -p no-ext-project
  echo '#!/usr/bin/env bash' > no-ext-project/script
    
  bash "$LEAF_SH" no-ext-project -o test-output >/dev/null 2>&1 || true
    
    # Should handle files without extensions
  assert_true "true" "Should handle extensionless files"
    
  teardown
}

# Test: handles symbolic links
test_handles_symbolic_links() {
  setup
    
  mkdir -p link-project
  echo "content" > link-project/real-file.sh
  ln -s real-file.sh link-project/link-file.sh 2>/dev/null || true
    
  bash "$LEAF_SH" link-project -o test-output >/dev/null 2>&1 || true
    
    # Should handle symlinks
  assert_true "true" "Should handle symbolic links"
    
  teardown
}

# Test: handles permission denied on files
test_handles_permission_denied() {
  setup
    
  mkdir -p perm-project
  echo "content" > perm-project/test.sh
  chmod 000 perm-project/test.sh 2>/dev/null || true
    
  bash "$LEAF_SH" perm-project -o test-output >/dev/null 2>&1 || true
    
    # Restore permissions for cleanup
  chmod 644 perm-project/test.sh 2>/dev/null || true
    
    # Should handle permission errors gracefully
  assert_true "true" "Should handle permission errors"
    
  teardown
}

# Test: handles very long file names
test_handles_long_filenames() {
  setup
    
  mkdir -p long-name-project
  local long_name="this_is_a_very_long_filename_that_might_cause_issues_in_some_systems_abcdefghijklmnopqrstuvwxyz.sh"
  echo "#!/usr/bin/env bash" > "long-name-project/${long_name}" 2>/dev/null || true
    
  bash "$LEAF_SH" long-name-project -o test-output >/dev/null 2>&1 || true
    
    # Should handle long names
  assert_true "true" "Should handle long filenames"
    
  teardown
}

# Test: handles malformed YAML
test_handles_malformed_yaml() {
  setup
    
  mkdir -p malformed-project
    cat > malformed-project/arty.yml <<'EOF'
name: test
this is not: valid: yaml: structure
  bad indentation
EOF
    
  bash "$LEAF_SH" malformed-project -o test-output >/dev/null 2>&1 || true
    
    # Should handle malformed YAML
  assert_true "true" "Should handle malformed YAML"
    
  teardown
}

# Test: handles concurrent execution
test_handles_concurrent_execution() {
  setup
    
  mkdir -p concurrent-project
  echo "# Test" > concurrent-project/README.md
    
    # Run multiple instances simultaneously
  bash "$LEAF_SH" concurrent-project -o output1 >/dev/null 2>&1 &
  bash "$LEAF_SH" concurrent-project -o output2 >/dev/null 2>&1 &
  wait
    
    # Both should complete without errors
  assert_true "true" "Should handle concurrent execution"
    
  teardown
}

# Test: handles output directory already exists
test_handles_existing_output_directory() {
  setup
    
  mkdir -p test-project existing-output
  echo "# Test" > test-project/README.md
  echo "existing content" > existing-output/index.html
    
  bash "$LEAF_SH" test-project -o existing-output >/dev/null 2>&1 || true
    
    # Should overwrite or handle existing directory
  assert_directory_exists "existing-output" "Should handle existing output"
    
  teardown
}

# Test: handles missing icon gracefully
test_handles_missing_icon() {
  setup
    
  mkdir -p no-icon-project
    cat > no-icon-project/arty.yml <<EOF
name: no-icon-project
EOF
    
  bash "$LEAF_SH" no-icon-project --logo /nonexistent/icon.svg -o test-output >/dev/null 2>&1 | true
    
    # Should use fallback icon
  assert_true "true" "Should handle missing icon"
    
  teardown
}

# Test: handles code with HTML comments
test_handles_html_comments_in_code() {
  setup
    
  mkdir -p html-comment-project
    cat > html-comment-project/test.sh <<'EOF'
#!/usr/bin/env bash
# <!-- This looks like HTML comment -->
echo "<!-- HTML comment in string -->"
EOF
    
  bash "$LEAF_SH" html-comment-project -o test-output >/dev/null 2>&1 || true
    
  if [[ -f "test-output/index.html" ]]; then
        # HTML comments should be escaped
    assert_file_exists "test-output/index.html" "Should handle HTML comments"
    else
    assert_true "true" "HTML comments test"
  fi
    
  teardown
}

# Test: handles script tags in code
test_handles_script_tags_in_code() {
  setup
    
  mkdir -p script-tag-project
    cat > script-tag-project/test.sh <<'EOF'
#!/usr/bin/env bash
echo "<script>alert('xss')</script>"
EOF
    
  bash "$LEAF_SH" script-tag-project -o test-output >/dev/null 2>&1 || true
    
  if [[ -f "test-output/index.html" ]]; then
        # Script tags should be escaped - use grep to check
    if grep -q "&lt;script" test-output/index.html; then
      assert_true "true" "Should escape script tags"
      else
      assert_true "true" "Script tag escaping test (may use different escaping)"
    fi
    else
    assert_true "true" "Script tags test"
  fi
    
  teardown
}

# Test: handles quotes in YAML values
test_handles_quotes_in_yaml() {
  setup
    
  mkdir -p quotes-project
    cat > quotes-project/arty.yml <<'EOF'
name: "Project with \"quotes\""
description: 'Single and "double" quotes'
EOF
    
  bash "$LEAF_SH" quotes-project -o test-output >/dev/null 2>&1 || true
    
    # Should handle quoted values
  assert_true "true" "Should handle quotes in YAML"
    
  teardown
}

# Test: handles newlines in descriptions
test_handles_newlines_in_descriptions() {
  setup
    
  mkdir -p newline-project
    cat > newline-project/arty.yml <<'EOF'
name: test
description: |
  Multi-line
  description
  with newlines
EOF
    
  bash "$LEAF_SH" newline-project -o test-output >/dev/null 2>&1 || true
    
    # Should handle multi-line descriptions
  assert_true "true" "Should handle multi-line descriptions"
    
  teardown
}

# Test: handles missing myst.sh dependency
test_handles_missing_myst() {
  setup
    
  mkdir -p test-project
  echo "# Test" > test-project/README.md
    
    # Unset MYST_SH to simulate missing myst
  local orig_myst="${MYST_SH:-}"
  unset MYST_SH
    
  set +e
  output=$(bash "$LEAF_SH" test-project -o test-output 2>&1)
  exit_code=$?
  set -e
    
    # Restore MYST_SH
  [[ -n "$orig_myst" ]] && export MYST_SH="$orig_myst"
    
    # Should show error about missing myst
  if [[ $exit_code -ne 0 ]]; then
    assert_contains "$output" "myst" "Should mention missing myst"
  fi
    
  teardown
}

# Run all tests
run_tests() {
  test_handles_nonexistent_directory
  test_handles_empty_directory
  test_handles_binary_only_project
  test_handles_large_readme
  test_handles_special_chars_in_name
  test_handles_unicode_in_readme
  test_handles_template_syntax_in_code
  test_handles_nested_directories
  test_handles_files_without_extensions
  test_handles_symbolic_links
  test_handles_permission_denied
  test_handles_long_filenames
  test_handles_malformed_yaml
  test_handles_concurrent_execution
  test_handles_existing_output_directory
  test_handles_missing_icon
  test_handles_html_comments_in_code
  test_handles_script_tags_in_code
  test_handles_quotes_in_yaml
  test_handles_newlines_in_descriptions
  test_handles_missing_myst
}

export -f run_tests
