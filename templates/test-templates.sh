#!/usr/bin/env bash

# test-templates.sh - Test myst templates for leaf.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="${SCRIPT_DIR}"
EXAMPLES_DIR="${TEMPLATES_DIR}/examples"
OUTPUT_DIR="${SCRIPT_DIR}/test-output"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}Testing leaf.sh Myst Templates${NC}"
echo "========================================"
echo

# Check if myst.sh is available
if ! command -v myst >/dev/null 2>&1; then
    # Try to find myst.sh in parent directories
    MYST_PATH=""
    if [[ -f "${SCRIPT_DIR}/../../myst/myst.sh" ]]; then
        MYST_PATH="${SCRIPT_DIR}/../../myst/myst.sh"
    elif [[ -f "${SCRIPT_DIR}/../../../myst.sh/myst.sh" ]]; then
        MYST_PATH="${SCRIPT_DIR}/../../../myst.sh/myst.sh"
    else
        echo -e "${YELLOW}Warning: myst.sh not found in PATH or nearby directories${NC}"
        echo "Please install myst.sh or add it to PATH"
        echo
        echo "You can test manually with:"
        echo "  myst render templates/landing.html.myst -p templates/partials -j examples/landing-data.json -o output.html"
        exit 1
    fi
    
    MYST_CMD="bash ${MYST_PATH}"
else
    MYST_CMD="myst"
fi

echo -e "${GREEN}✓${NC} Found myst: $MYST_CMD"
echo

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Test 1: Landing page
echo -e "${BLUE}[Test 1]${NC} Rendering landing.html.myst..."
$MYST_CMD render "${TEMPLATES_DIR}/landing.html.myst" \
    -p "${TEMPLATES_DIR}/partials" \
    -j "${EXAMPLES_DIR}/landing-data.json" \
    -o "${OUTPUT_DIR}/landing.html" 2>&1 | grep -v "^\[" || true

if [[ -f "${OUTPUT_DIR}/landing.html" ]]; then
    echo -e "${GREEN}✓${NC} Generated: ${OUTPUT_DIR}/landing.html"
else
    echo -e "${YELLOW}✗${NC} Failed to generate landing.html"
fi
echo

# Test 2: Project page
echo -e "${BLUE}[Test 2]${NC} Rendering project.html.myst..."
$MYST_CMD render "${TEMPLATES_DIR}/project.html.myst" \
    -p "${TEMPLATES_DIR}/partials" \
    -j "${EXAMPLES_DIR}/project-data.json" \
    -o "${OUTPUT_DIR}/project.html" 2>&1 | grep -v "^\[" || true

if [[ -f "${OUTPUT_DIR}/project.html" ]]; then
    echo -e "${GREEN}✓${NC} Generated: ${OUTPUT_DIR}/project.html"
else
    echo -e "${YELLOW}✗${NC} Failed to generate project.html"
fi
echo

# Summary
echo "========================================"
echo -e "${GREEN}Testing Complete!${NC}"
echo
echo "Generated files:"
ls -lh "$OUTPUT_DIR"
echo
echo "To view the generated pages:"
echo -e "  ${BLUE}file://${OUTPUT_DIR}/landing.html${NC}"
echo -e "  ${BLUE}file://${OUTPUT_DIR}/project.html${NC}"
echo
echo "Or start a local server:"
echo -e "  ${YELLOW}cd ${OUTPUT_DIR} && python3 -m http.server 8080${NC}"
echo
