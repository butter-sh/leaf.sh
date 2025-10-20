#!/usr/bin/env bash
# Simple test to debug assert_contains

test_simple_output_check() {
    echo "Running simple output check..."
    
    # Get output
    output=$(bash "$LEAF_SH" --help 2>&1)
    
    echo "Output length: ${#output}"
    echo "Output (first 500 chars):"
    echo "${output:0:500}"
    echo ""
    echo "---"
    echo ""
    
    # Check if USAGE: is in output
    if echo "$output" | grep -qF "USAGE:"; then
        echo "✓ Found USAGE: with grep -qF"
    else
        echo "✗ Did not find USAGE: with grep -qF"
    fi
    
    # Check with case-insensitive
    if echo "$output" | grep -qiF "USAGE:"; then
        echo "✓ Found USAGE: with grep -qiF"
    else
        echo "✗ Did not find USAGE: with grep -qiF"
    fi
    
    # Now test with assert_contains
    echo ""
    echo "Testing with assert_contains..."
    assert_contains "$output" "USAGE:" "Should contain USAGE:"
    assert_contains "$output" "leaf.sh" "Should contain leaf.sh"
}

run_tests() {
    test_simple_output_check
}

export -f run_tests
