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
  --icon PATH             Path to icon SVG file
  --logo PATH             Path to logo SVG file

LANDING TEMPLATE OPTIONS:
  --github-url URL        GitHub URL for organization/project
  --base-url URL          Base URL for project links
  --logo PATH             Path to logo SVG file

NOTE:
  leaf.sh automatically reads name, version, description, author, and
  license from arty.yml in the current working directory.

EXAMPLES:
  # Generate project documentation (reads from ./arty.yml)
  leaf docs -o docs/ --icon icon.svg

  # Generate landing page with logo
  leaf landing -o index.html --logo logo.svg --github-url https://github.com/myorg

  # Non-interactive mode
  leaf docs -o docs/ --icon icon.svg --yes --force

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

  # Find myst.sh for CSS rendering
        local myst_path=""
        if [[ -n "${MYST_SH:-}" ]] && [[ -x "${MYST_SH}" ]]; then
          myst_path="${MYST_SH}"
          elif [[ -x "${PWD}/.arty/bin/myst" ]]; then
            myst_path="${PWD}/.arty/bin/myst"
            elif [[ -x "${REAL_SCRIPT_DIR}/.arty/bin/myst" ]]; then
              myst_path="${REAL_SCRIPT_DIR}/.arty/bin/myst"
              elif command -v myst &>/dev/null; then
                myst_path="myst"
              fi

  # Read arty.yml from current directory
              read_arty_yml "$template" || exit 1

  # Build hammer.sh command
              local hammer_cmd=("$hammer_path" "$template")

  # Parse arguments and build hammer.sh command
              local output_dir=""
              local hammer_args=()
              local var_args=()
              local logo_path=""
              local icon_path=""

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
                --logo)
                logo_path="$2"
                shift 2
                ;;
                --icon)
                icon_path="$2"
                shift 2
                ;;
                --github-url|--base-path|--base-url)
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
            [[ -n "${ARTY_VERSION:-}" ]] && hammer_cmd+=("--var" "project_version=${ARTY_VERSION}")
            [[ -n "${ARTY_DESCRIPTION:-}" ]] && hammer_cmd+=("--var" "project_description=${ARTY_DESCRIPTION}")
            [[ -n "${ARTY_AUTHOR:-}" ]] && hammer_cmd+=("--var" "project_author=${ARTY_AUTHOR}")
            [[ -n "${ARTY_LICENSE:-}" ]] && hammer_cmd+=("--var" "project_license=${ARTY_LICENSE}")

  # For landing page, use site_name; for docs, use project_name
            if [[ "$template" == "landing" ]] && [[ -n "${ARTY_NAME:-}" ]]; then
              hammer_cmd+=("--var" "site_name=${ARTY_NAME}")
              hammer_cmd+=("--var" "project_name=${ARTY_NAME}")
              # Landing page nav links
              local landing_nav='<a href="#projects" class="text-slate-300 hover:text-white transition scroll-smooth" style="hover: color: var(--carbon-light);">Projects</a>'
              hammer_cmd+=("--var" "nav_links=$landing_nav")
              elif [[ -n "${ARTY_NAME:-}" ]]; then
                hammer_cmd+=("--var" "project_name=${ARTY_NAME}")
              # Docs page nav links
                local docs_nav='<a href="/" class="text-slate-300 hover:text-white transition" style="hover: color: var(--carbon-light);">Home</a>
                <a href="#overview" class="text-slate-300 hover:text-white transition" style="hover: color: var(--carbon-light);">Overview</a>
                <a href="#source" class="text-slate-300 hover:text-white transition">Source</a>'
                hammer_cmd+=("--var" "nav_links=$docs_nav")
              fi

  # Pass icon/logo filenames if paths provided (files will be copied later)
              if [[ -n "$icon_path" ]] && [[ -f "$icon_path" ]]; then
                local icon_filename
                icon_filename=$(basename "$icon_path")
                hammer_cmd+=("--var" "icon=$icon_filename")
              fi

              if [[ -n "$logo_path" ]] && [[ -f "$logo_path" ]]; then
                local logo_filename
                logo_filename=$(basename "$logo_path")
                hammer_cmd+=("--var" "logo=$logo_filename")
              fi

  # Add projects array for landing template
              if [[ "$template" == "landing" ]] && [[ -n "${ARTY_PROJECTS:-}" ]]; then
        # Write projects JSON to a temp file and use hammer's --json flag
        # Wrap the array in an object with "projects" key for myst.sh
                local projects_file="/tmp/leaf-projects-$$.json"
                echo "{\"projects\":$ARTY_PROJECTS}" > "$projects_file"
                hammer_cmd+=("--json" "$projects_file")
              fi

  # Add source files for docs template
              if [[ "$template" == "docs" ]]; then
        # Find all .sh files in current directory (non-recursive, exclude hidden dirs)
                local source_files=()
                while IFS= read -r -d '' file; do
                  source_files+=("$(basename "$file")")
                done < <(find . -maxdepth 1 -name "*.sh" -type f -print0 2>/dev/null)

        # Generate JSON array of source filenames
                local source_files_json="["
                for i in "${!source_files[@]}"; do
                  source_files_json+="\"${source_files[$i]}\""
                  [[ $i -lt $((${#source_files[@]} - 1)) ]] && source_files_json+=","
                done
                source_files_json+="]"

                hammer_cmd+=("--var" "source_files_json=$source_files_json")
              fi

  # Add user-provided variable arguments (these override arty.yml values)
              if [[ ${#var_args[@]} -gt 0 ]]; then
                hammer_cmd+=("${var_args[@]}")
              fi

  # Execute hammer.sh
              log_info "Generating ${template} documentation..."
              log_info "Command: ${hammer_cmd[*]}"

              if "${hammer_cmd[@]}"; then
        # Post-process: copy carbon.css from partials
                local carbon_css="${TEMPLATES_DIR}/_partials/_carbon.css.myst"
                if [[ -f "$carbon_css" ]]; then
          # Render the CSS template (in case it has variables, though currently it doesn't)
                  if [[ -n "$myst_path" ]]; then
                    "$myst_path" "$carbon_css" > "$output_dir/carbon.css" 2>/dev/null || \
                    cat "$carbon_css" > "$output_dir/carbon.css"
                    else
            # Fallback: just copy the file without .myst extension
                    cat "$carbon_css" > "$output_dir/carbon.css"
                  fi
                  log_success "Copied carbon.css"
                fi

        # Post-process: copy icon/logo files if provided
                if [[ -n "$icon_path" ]] && [[ -f "$icon_path" ]]; then
                  cp "$icon_path" "$output_dir/"
                  log_success "Copied $(basename "$icon_path")"
                fi

                if [[ -n "$logo_path" ]] && [[ -f "$logo_path" ]]; then
                  cp "$logo_path" "$output_dir/"
                  log_success "Copied $(basename "$logo_path")"
                fi

        # Post-process for docs template: copy README and source files
                if [[ "$template" == "docs" ]]; then
                  log_info "Copying README and source files..."

          # Copy README.md if it exists
                  if [[ -f "README.md" ]]; then
                    cp "README.md" "$output_dir/"
                    log_success "Copied README.md"
                  fi

          # Create source directory and copy .sh files
                  if [[ ${#source_files[@]} -gt 0 ]]; then
                    mkdir -p "$output_dir/source"
                    for file in "${source_files[@]}"; do
                      if [[ -f "$file" ]]; then
                        cp "$file" "$output_dir/source/"
                        log_success "Copied $file"
                      fi
                    done
                  fi
                fi

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
