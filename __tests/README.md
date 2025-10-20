# leaf.sh Test Suite

This directory contains the test suite for leaf.sh using the judge.sh testing framework.

## Quick Start

### 1. Setup (First Time Only)
```bash
cd /home/valknar/Projects/butter.sh/projects/leaf.sh/__tests
chmod +x setup-tests.sh
./setup-tests.sh
```

This will:
- Make leaf.sh executable
- Check for required dependencies
- Verify the test environment

### 2. Run Tests
```bash
cd /home/valknar/Projects/butter.sh/projects/leaf.sh
./run-tests.sh
```

## Test Files

- **test-config.sh** - Test configuration and environment setup
- **test-leaf-core.sh** - Core functionality tests (CLI, options, basic generation)
- **test-leaf-landing.sh** - Landing page generation tests
- **test-leaf-edge-cases.sh** - Edge cases and error handling tests
- **setup-tests.sh** - Setup script to prepare test environment

## Running Tests

### Run all tests
```bash
# From leaf.sh root directory
./run-tests.sh

# Or directly with judge.sh
bash ../judge.sh/judge.sh run
```

### Run specific test suite
```bash
bash ../judge.sh/judge.sh run -t test-leaf-core
bash ../judge.sh/judge.sh run -t test-leaf-landing
bash ../judge.sh/judge.sh run -t test-leaf-edge-cases
```

### Run with verbose output
```bash
./run-tests.sh -v
```

### Update snapshots
```bash
bash ../judge.sh/judge.sh run -u
```

## Troubleshooting

### "leaf.sh should be executable" test fails

Run the setup script:
```bash
cd __tests
./setup-tests.sh
```

Or manually:
```bash
chmod +x /home/valknar/Projects/butter.sh/projects/leaf.sh/leaf.sh
```

### "USAGE:" not found / empty output

This usually means:
1. leaf.sh is not executable (run `chmod +x leaf.sh`)
2. Dependencies are missing (run `__tests/setup-tests.sh` to check)
3. LEAF_SH path is incorrect (verify in test-config.sh)

### Missing dependencies error

Install required dependencies:
```bash
# yq (YAML processor)
# See: https://github.com/mikefarah/yq#install

# jq (JSON processor)
sudo apt-get install jq  # Debian/Ubuntu
brew install jq          # macOS

# myst.sh (template engine)
cd /home/valknar/Projects/butter.sh/projects/leaf.sh
arty deps
```

## Test Coverage

### Core Functionality (test-leaf-core.sh)
- CLI argument parsing
- Help and usage display
- Basic documentation generation
- Project metadata processing (arty.yml)
- README.md processing
- Source file detection and display
- Example file detection and display
- HTML escaping and security
- Language detection
- Custom options (logo, output, base-path, github)

### Landing Page (test-leaf-landing.sh)
- Landing page generation mode
- Projects JSON handling (file and inline)
- Custom logo support
- Custom GitHub URL
- Default projects fallback
- HTML structure validation
- Meta tags and styling

### Edge Cases (test-leaf-edge-cases.sh)
- Non-existent directories
- Empty projects
- Binary-only projects
- Large files
- Special characters (Unicode, HTML, quotes)
- Template syntax in code
- Nested directory structures
- File permissions
- Malformed YAML
- Concurrent execution
- Missing dependencies (myst.sh)
- Security (XSS prevention)

## Test Structure

Each test file follows this pattern:

```bash
#!/usr/bin/env bash
# Test suite description

setup() {
  # Create test environment
  TEST_ENV_DIR=$(create_test_env)
  cd "$TEST_ENV_DIR"
  # Setup test fixtures
}

teardown() {
  # Cleanup test environment
  cleanup_test_env
}

test_something() {
  setup
  # Test code
  # Assertions
  teardown
}

run_tests() {
  test_something
  # More tests...
}

export -f run_tests
```

## Dependencies

- **judge.sh** (testing framework)
- **yq** (YAML processing)
- **jq** (JSON processing)
- **myst.sh** (template rendering)
- **bash** 4.0+

Install with:
```bash
cd leaf.sh
arty deps
```

## Writing New Tests

1. Add test functions to appropriate test file or create new file
2. Follow naming convention: `test_description_of_what_is_tested`
3. Use setup() and teardown() for test isolation
4. Use assertion functions: `assert_equals`, `assert_contains`, `assert_true`, etc.
5. Add test to `run_tests()` function
6. Export run_tests function

## Important Notes

### Avoiding Command Substitution Issues

Tests should NOT load HTML/CSS content into bash variables, as this causes bash to try interpreting CSS syntax like `@import url()` as commands.

**❌ Don't do this:**
```bash
content=$(cat output.html)
assert_contains "$content" "something"
```

**✅ Do this instead:**
```bash
# Use grep directly on files
if grep -q "something" output.html; then
    assert_true "true" "Should contain something"
fi
```

## CI/CD Integration

Tests can be run in CI/CD pipelines:

```yaml
# GitHub Actions example
- name: Setup tests
  run: |
    cd butter.sh/projects/leaf.sh/__tests
    ./setup-tests.sh

- name: Run tests
  run: |
    cd butter.sh/projects/leaf.sh
    ./run-tests.sh
```

## Snapshot Testing

Initialize snapshots:
```bash
bash ../judge.sh/judge.sh setup
```

Manage snapshots:
```bash
# List snapshots
bash ../judge.sh/judge.sh snap list

# Compare snapshot
bash ../judge.sh/judge.sh snap diff test-name

# Show statistics
bash ../judge.sh/judge.sh snap stats
```
