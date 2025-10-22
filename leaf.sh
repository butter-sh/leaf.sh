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

# Read arty.yml from current directory
      read_arty_yml() {
        local arty_file="${PWD}/arty.yml"
        local template="${1:-}"

        if [[ ! -f "$arty_file" ]]; then
          return 0  # No arty.yml found, continue without it
        fi

  # Check if yq is available
        if ! command -v yq &>/dev/null; then
          log_error "yq is required to read arty.yml"
          return 1
        fi

  # Extract values from arty.yml
        local name version description author license
        name=$(yq eval '.name // ""' "$arty_file" 2>/dev/null || echo "")
        version=$(yq eval '.version // ""' "$arty_file" 2>/dev/null || echo "")
        description=$(yq eval '.description // ""' "$arty_file" 2>/dev/null || echo "")
        author=$(yq eval '.author // ""' "$arty_file" 2>/dev/null || echo "")
        license=$(yq eval '.license // ""' "$arty_file" 2>/dev/null || echo "")

  # Export as variables for use in main
        export ARTY_NAME="$name"
        export ARTY_VERSION="$version"
        export ARTY_DESCRIPTION="$description"
        export ARTY_AUTHOR="$author"
        export ARTY_LICENSE="$license"

  # For landing template, read projects array from leaf.landing.projects or hammer.templates.landing.projects
        if [[ "$template" == "landing" ]]; then
          local projects_json
          projects_json=$(yq eval '.leaf.landing.projects // .hammer.templates.landing.projects // []' "$arty_file" -o=json 2>/dev/null || echo "[]")
          export ARTY_PROJECTS="$projects_json"
        fi
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
  --github-url URL        GitHub repository URL
  --base-path PATH        Base path for links (default: /)
  --logo PATH             Path to logo file

LANDING TEMPLATE OPTIONS:
  --projects FILE         Projects JSON file (required)
  --github-org URL        GitHub organization URL
  --base-url URL          Base URL for project links

NOTE:
  leaf.sh automatically reads name, version, description, author, and
  license from arty.yml in the current working directory.

EXAMPLES:
  # Generate project documentation (reads from ./arty.yml)
  leaf docs -o docs/ --logo icon.svg

  # Generate landing page
  leaf landing -o index.html --projects projects.json

  # Non-interactive mode
  leaf docs -o docs/ --yes --force

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

  # Read arty.yml from current directory
        read_arty_yml "$template" || exit 1

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
          --github-url|--base-path|--logo|--github-org|--base-url)
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
      if [[ ${#hammer_args[@]} -gt 0 ]]; then
        hammer_cmd+=("${hammer_args[@]}")
      fi

  # Add arty.yml values as variables (prefixed with project_)
      [[ -n "${ARTY_NAME:-}" ]] && hammer_cmd+=("--var" "project_name=${ARTY_NAME}")
      [[ -n "${ARTY_VERSION:-}" ]] && hammer_cmd+=("--var" "project_version=${ARTY_VERSION}")
      [[ -n "${ARTY_DESCRIPTION:-}" ]] && hammer_cmd+=("--var" "project_description=${ARTY_DESCRIPTION}")
      [[ -n "${ARTY_AUTHOR:-}" ]] && hammer_cmd+=("--var" "project_author=${ARTY_AUTHOR}")
      [[ -n "${ARTY_LICENSE:-}" ]] && hammer_cmd+=("--var" "project_license=${ARTY_LICENSE}")

  # Add projects array for landing template
      if [[ "$template" == "landing" ]] && [[ -n "${ARTY_PROJECTS:-}" ]]; then
        # Generate project cards HTML from JSON using the partial
        local projects_html=""
        local project_count=$(echo "$ARTY_PROJECTS" | jq 'length')
        local partial_template="${TEMPLATES_DIR}/landing/partials/project-card.myst"

        if [[ -f "$partial_template" ]]; then
          for ((i=0; i<project_count; i++)); do
            local url=$(echo "$ARTY_PROJECTS" | jq -r ".[$i].url // \"\"")
            local label=$(echo "$ARTY_PROJECTS" | jq -r ".[$i].label // \"\"")
            local desc=$(echo "$ARTY_PROJECTS" | jq -r ".[$i].desc // \"\"")
            local tagline=$(echo "$ARTY_PROJECTS" | jq -r ".[$i].tagline // \"\"")

            # Render the partial with project variables
            local card_html=$(cat "$partial_template" | \
              sed "s|{{url}}|$url|g" | \
              sed "s|{{label}}|$label|g" | \
              sed "s|{{desc}}|$desc|g" | \
              sed "s|{{tagline}}|$tagline|g")

            projects_html+="$card_html"$'\n'
          done
        fi

        hammer_cmd+=("--var" "projects_html=$projects_html")
      fi

  # Add user-provided variable arguments (these override arty.yml values)
      if [[ ${#var_args[@]} -gt 0 ]]; then
        hammer_cmd+=("${var_args[@]}")
      fi

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
