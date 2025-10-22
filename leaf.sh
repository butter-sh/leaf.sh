#!/usr/bin/env bash
# leaf.sh - Documentation generator using hammer.sh templates
# Version: 2.0.0 - Refactored to use hammer.sh as generation engine

set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REAL_BASH_SOURCE="$(readlink -f "${BASH_SOURCE[0]}")"
REAL_SCRIPT_DIR="$(cd "$(dirname "${REAL_BASH_SOURCE}")" && pwd)"
TEMPLATES_DIR="${REAL_SCRIPT_DIR}/templates"

# Colors for output
export FORCE_COLOR=${FORCE_COLOR:-"1"}
if [[ "$FORCE_COLOR" = "0" ]]; then
  RED='' GREEN='' YELLOW='' BLUE='' NC=''
else
  RED='\033[0;31m' GREEN='\033[0;32m' YELLOW='\033[1;33m'
  BLUE='\033[0;34m' NC='\033[0m'
fi

# Helper functions
log_info() { echo -e "${BLUE}ℹ${NC} $1"; }
log_success() { echo -e "${GREEN}✓${NC} $1"; }
log_error() { echo -e "${RED}✗${NC} $1" >&2; }

# Find hammer.sh
find_hammer() {
  local hammer_path=""

  # Check various locations
  if [[ -n "${HAMMER_SH:-}" ]] && [[ -x "${HAMMER_SH}" ]]; then
    hammer_path="${HAMMER_SH}"
  elif [[ -x "${PWD}/.arty/bin/hammer" ]]; then
    hammer_path="${PWD}/.arty/bin/hammer"
  elif [[ -x "${REAL_SCRIPT_DIR}/.arty/bin/hammer" ]]; then
    hammer_path="${REAL_SCRIPT_DIR}/.arty/bin/hammer"
  elif command -v hammer &>/dev/null; then
    hammer_path="hammer"
  else
    log_error "hammer.sh not found. Please install it with 'arty deps'"
    return 1
  fi

  echo "$hammer_path"
}

# Show help
show_help() {
  cat << 'EOF'
leaf.sh - Documentation generator using hammer.sh templates

USAGE:
  leaf <template> [options]

TEMPLATES:
  docs        Generate project documentation
  landing     Generate ecosystem landing page

COMMON OPTIONS:
  -o, --output DIR        Output directory (required)
  --yes                   Non-interactive mode (skip prompts)
  --force                 Force overwrite existing files
  -h, --help              Show this help

DOCS TEMPLATE OPTIONS:
  --project-dir DIR       Project directory (default: current directory)
  --name NAME             Project name
  --version VERSION       Project version
  --description DESC      Project description
  --author AUTHOR         Project author
  --license LICENSE       License type
  --github-url URL        GitHub repository URL
  --base-path PATH        Base path for links (default: /)
  --logo PATH             Path to logo file

LANDING TEMPLATE OPTIONS:
  --projects FILE         Projects JSON file (required)
  --title TITLE           Landing page title
  --description DESC      Landing page description
  --github-org URL        GitHub organization URL
  --base-url URL          Base URL for project links

EXAMPLES:
  # Generate project documentation
  leaf docs -o docs/ --project-dir . --logo icon.svg

  # Generate landing page
  leaf landing -o index.html --projects projects.json

  # Non-interactive with all options
  leaf docs -o docs/ --yes --force \
    --name "my-project" \
    --version "1.0.0" \
    --description "A cool project"

EOF
}

# Main function
main() {
  # Check for help first
  for arg in "$@"; do
    if [[ "$arg" == "-h" ]] || [[ "$arg" == "--help" ]]; then
      show_help
      exit 0
    fi
  done

  # Check for template subcommand
  if [[ $# -eq 0 ]]; then
    log_error "No template specified"
    echo
    show_help
    exit 1
  fi

  local template="$1"
  shift

  # Validate template exists
  if [[ ! -d "${TEMPLATES_DIR}/${template}" ]]; then
    log_error "Template '${template}' not found in ${TEMPLATES_DIR}"
    log_info "Available templates: docs, landing"
    exit 1
  fi

  # Find hammer.sh
  local hammer_path
  hammer_path=$(find_hammer) || exit 1

  # Build hammer.sh command
  local hammer_cmd=("$hammer_path" "$template")

  # Parse arguments and build hammer.sh command
  local output_dir=""
  local hammer_args=()
  local var_args=()

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -o|--output)
        output_dir="$2"
        shift 2
        ;;
      --yes)
        hammer_args+=("--yes")
        shift
        ;;
      --force)
        hammer_args+=("--force")
        shift
        ;;
      --project-dir|--name|--version|--description|--author|--license|--github-url|--base-path|--logo|--projects|--title|--github-org|--base-url)
        local key="${1#--}"
        key="${key//-/_}"  # Replace hyphens with underscores
        var_args+=("--var" "${key}=$2")
        shift 2
        ;;
      -h|--help)
        show_help
        exit 0
        ;;
      *)
        log_error "Unknown option: $1"
        echo
        show_help
        exit 1
        ;;
    esac
  done

  # Validate output directory
  if [[ -z "$output_dir" ]]; then
    log_error "Output directory (-o, --output) is required"
    exit 1
  fi

  # Add output directory to hammer command
  hammer_cmd+=("$output_dir")

  # Add template directory
  hammer_cmd+=("--template-dir" "${TEMPLATES_DIR}")

  # Add hammer options
  hammer_cmd+=("${hammer_args[@]}")

  # Add variable arguments
  hammer_cmd+=("${var_args[@]}")

  # Execute hammer.sh
  log_info "Generating ${template} documentation..."
  log_info "Command: ${hammer_cmd[*]}"

  if "${hammer_cmd[@]}"; then
    log_success "Documentation generated successfully"
    log_info "Output: ${output_dir}"
    exit 0
  else
    log_error "Generation failed"
    exit 1
  fi
}

# Run main if not sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
