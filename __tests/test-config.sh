#!/usr/bin/env bash
# Test configuration for leaf.sh test suite
# This file is sourced by test files to set common configuration

export TEST_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Test directory structure
export LEAF_SH_ROOT="$(cd "$TEST_ROOT/.." && pwd)"
export LEAF_SH="$LEAF_SH_ROOT/leaf.sh"

# Debug: Print path (only if VERBOSE is set)
if [[ "${VERBOSE:-0}" == "1" ]]; then
    echo "[DEBUG test-config.sh] TEST_ROOT=$TEST_ROOT"
    echo "[DEBUG test-config.sh] LEAF_SH_ROOT=$LEAF_SH_ROOT"
    echo "[DEBUG test-config.sh] LEAF_SH=$LEAF_SH"
    if [[ -f "$LEAF_SH" ]]; then
        echo "[DEBUG test-config.sh] leaf.sh exists: YES"
        echo "[DEBUG test-config.sh] leaf.sh executable: $(test -x "$LEAF_SH" && echo YES || echo NO)"
    else
        echo "[DEBUG test-config.sh] leaf.sh exists: NO"
    fi
fi

# Verify leaf.sh exists
if [[ ! -f "$LEAF_SH" ]]; then
    echo "ERROR: leaf.sh not found at: $LEAF_SH" >&2
    echo "TEST_ROOT: $TEST_ROOT" >&2
    echo "LEAF_SH_ROOT: $LEAF_SH_ROOT" >&2
    exit 1
fi

# Test behavior flags
export LEAF_TEST_MODE=1
export LEAF_TEST_COLORS=1
export FORCE_COLOR=1
export DEBUG=0
