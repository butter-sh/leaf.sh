#!/usr/bin/env bash
# Debug test to check LEAF_SH variable

# This test doesn't use setup/teardown to test the raw environment

test_debug_leaf_sh_path() {
    echo "DEBUG: LEAF_SH=$LEAF_SH"
    echo "DEBUG: TEST_ROOT=$TEST_ROOT"
    echo "DEBUG: LEAF_SH_ROOT=$LEAF_SH_ROOT"
    
    if [[ -z "$LEAF_SH" ]]; then
        echo "ERROR: LEAF_SH is not set!"
        return 1
    fi
    
    if [[ ! -f "$LEAF_SH" ]]; then
        echo "ERROR: LEAF_SH file does not exist: $LEAF_SH"
        return 1
    fi
    
    if [[ ! -x "$LEAF_SH" ]]; then
        echo "ERROR: LEAF_SH is not executable: $LEAF_SH"
        return 1
    fi
    
    echo "SUCCESS: LEAF_SH is set and executable"
    
    # Try to run it
    echo "Testing direct execution..."
    output=$("$LEAF_SH" --help 2>&1)
    echo "Output length: ${#output}"
    echo "First 100 chars: ${output:0:100}"
    
    return 0
}

run_tests() {
    test_debug_leaf_sh_path
}

export -f run_tests
