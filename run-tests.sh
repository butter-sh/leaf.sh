#!/usr/bin/env bash
# Run all leaf.sh tests using judge.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

# Find judge.sh
JUDGE_SH=""
if [[ -x "../judge.sh/judge.sh" ]]; then
  JUDGE_SH="../judge.sh/judge.sh"
elif [[ -x ".arty/bin/judge" ]]; then
  JUDGE_SH=".arty/bin/judge"
elif command -v judge >/dev/null 2>&1; then
  JUDGE_SH="judge"
else
  echo "Error: judge.sh not found. Please install it or run 'arty deps'"
  exit 1
fi

# Run all tests
echo "Running all leaf.sh tests..."
bash "$JUDGE_SH" run "$@"
