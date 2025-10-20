#!/usr/bin/env bash
# Test to debug setup/teardown behavior

setup() {
  TEST_ENV_DIR=$(create_test_env)
  echo "DEBUG: TEST_ENV_DIR=$TEST_ENV_DIR"
  echo "DEBUG: PWD before cd: $PWD"
  cd "$TEST_ENV_DIR"
  echo "DEBUG: PWD after cd: $PWD"
  echo "DEBUG: LEAF_SH=$LEAF_SH"
}

teardown() {
  echo "DEBUG: In teardown, PWD=$PWD"
  cleanup_test_env
}

test_with_setup() {
    echo "=== Starting test ==="
    setup
    
    echo "In test after setup, PWD=$PWD"
    echo "LEAF_SH=$LEAF_SH"
    echo "Checking if LEAF_SH exists..."
    
    if [[ -f "$LEAF_SH" ]]; then
        echo "✓ LEAF_SH file exists"
    else
        echo "✗ LEAF_SH file does not exist!"
    fi
    
    if [[ -x "$LEAF_SH" ]]; then
        echo "✓ LEAF_SH is executable"
    else
        echo "✗ LEAF_SH is not executable!"
    fi
    
    echo "Running leaf.sh..."
    output=$(bash "$LEAF_SH" --help 2>&1)
    
    echo "Output captured, length: ${#output}"
    echo "First 200 chars: ${output:0:200}"
    
    if [[ -n "$output" ]]; then
        assert_contains "$output" "USAGE:" "Should show usage"
    else
        echo "ERROR: Output is empty!"
        assert_true "false" "Output should not be empty"
    fi
    
    teardown
    echo "=== Test complete ==="
}

run_tests() {
    test_with_setup
}

export -f run_tests
