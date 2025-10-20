#!/usr/bin/env bash
# leaf.sh - Beautiful documentation and landing page generator
# Version: 2.0.0 - Using myst.sh templating engine with proper escaping

# Only set strict mode when running directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  set -euo pipefail
fi

# Get script directory
if command -v dirname >/dev/null 2>&1; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
else
  SCRIPT_DIR="$(cd "${BASH_SOURCE[0]%/*}" && pwd)"
fi
REAL_BASH_SOURCE="$(readlink -f "${BASH_SOURCE[0]}")"
REAL_SCRIPT_DIR="$(cd "$(dirname "${REAL_BASH_SOURCE}")" && pwd)"
TEMPLATES_DIR="${REAL_SCRIPT_DIR}/templates"

# Colors for output
export FORCE_COLOR=${FORCE_COLOR:-"1"}
if [ "$FORCE_COLOR" = "0" ]; then
  export RED='' GREEN='' YELLOW='' BLUE='' CYAN='' MAGENTA='' BOLD='' NC=''
else
  export RED='\033[0;31m' GREEN='\033[0;32m' YELLOW='\033[1;33m'
  export BLUE='\033[0;34m' CYAN='\033[0;36m' MAGENTA='\033[0;35m'
  export BOLD='\033[1m' NC='\033[0m'
fi

# Default configuration
PROJECT_DIR=""
OUTPUT_DIR=""
MODE="docs"
LOGO_PATH=""
BASE_PATH="/"
GITHUB_URL="https://github.com/butter-sh"
PROJECTS_FILE=""
PROJECTS_JSON=""

# Helper functions
log_info() { echo -e "${BLUE}ℹ${NC} $1"; }
log_success() { echo -e "${GREEN}✓${NC} $1"; }
log_warn() { echo -e "${YELLOW}⚠${NC} $1"; }
log_error() { echo -e "${RED}✗${NC} $1"; }
log_debug() { [[ "${DEBUG:-0}" == "1" ]] && echo -e "${MAGENTA}🔍${NC} $1" >&2 || true; }

# Escape HTML for safe insertion
escape_html() {
  # Can accept input as parameter or via stdin
  local text="${1:-}"
  
  # If no parameter, read from stdin
  if [[ -z "$text" ]]; then
    text=$(cat)
  fi
  
  # If still empty, return empty
  if [[ -z "$text" ]]; then
    return
  fi
  
  # Use printf to avoid echo interpreting escape sequences
  printf '%s\n' "$text" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g; s/'"'"'/\&#39;/g'
}

# Find myst.sh
find_myst() {
  local myst_path=""
  if [[ -n "${MYST_SH:-}" ]] && [[ -x "${MYST_SH}" ]]; then
    myst_path="${MYST_SH}"
  elif [[ -x "${PWD}/.arty/bin/myst" ]]; then
    myst_path="${PWD}/.arty/bin/myst"
  elif [[ -x "${SCRIPT_DIR}/.arty/bin/myst" ]]; then
    myst_path="${SCRIPT_DIR}/.arty/bin/myst"
  elif [[ -x "${PWD}/../myst.sh/myst.sh" ]]; then
    myst_path="${PWD}/../myst.sh/myst.sh"
  elif command -v myst &>/dev/null; then
    myst_path="myst"
  else
    log_error "myst.sh not found. Please install it or run 'arty deps'" >&2
    return 1
  fi
  echo "$myst_path"
}

# Render template with myst - proper file path passing
render_with_myst() {
  local template="$1"
  local output="$2"
  local json_file="$3"
  
  local myst_path=$(find_myst)
  [[ -z "$myst_path" ]] && return 1
  
  log_debug "Using myst: $myst_path"
  log_debug "Template: $template"
  log_debug "Output: $output"
  log_debug "JSON file: $json_file"
  
  mkdir -p "$(dirname "$output")"
  
  if [[ ! -f "$template" ]]; then
    log_error "Template not found: $template"
    return 1
  fi
  
  if [[ ! -f "$json_file" ]]; then
    log_error "JSON data file not found: $json_file"
    return 1
  fi
  
  # Render with myst - pass template as file path, not content
  local myst_output
  local myst_exit_code
  
  # Log the exact command being run
  log_debug "Running: bash '$myst_path' -j '$json_file' -p '${TEMPLATES_DIR}/partials' -o '$output' '$template'"
  
  if myst_output=$(bash "$myst_path" \
    -j "$json_file" \
    -p "${TEMPLATES_DIR}/partials" \
    -o "$output" \
    "$template" 2>&1); then
    myst_exit_code=0
  else
    myst_exit_code=$?
  fi
  
  if [[ "${DEBUG:-0}" == "1" ]] || [[ $myst_exit_code -ne 0 ]]; then
    echo "$myst_output" | grep -v "^\[" || true
  fi
  
  if [[ $myst_exit_code -ne 0 ]]; then
    log_error "Myst rendering failed with exit code $myst_exit_code"
    return $myst_exit_code
  fi
  
  if [[ ! -f "$output" ]]; then
    log_error "Myst did not create output file: $output"
    return 1
  fi
  
  return 0
}

# Check dependencies
check_dependencies() {
  local missing_deps=()
  
  if ! command -v yq &>/dev/null; then
    missing_deps+=("yq")
  fi
  
  if ! command -v jq &>/dev/null; then
    missing_deps+=("jq")
  fi
  
  if [ ${#missing_deps[@]} -gt 0 ]; then
    log_error "Missing required dependencies: ${missing_deps[*]}" >&2
    log_info "Install yq: https://github.com/mikefarah/yq#install" >&2
    log_info "Install jq: https://stedolan.github.io/jq/download/" >&2
    return 1
  fi
  
  if ! find_myst >/dev/null 2>&1; then
    log_error "myst.sh not found" >&2
    log_info "Run 'arty deps' in the leaf.sh directory" >&2
    return 1
  fi
  
  return 0
}

# Show usage
show_usage() {
  cat <<'EOF'
╔═══════════════════════════════════════════╗
║                                           ║
║   🌿 leaf.sh - Documentation Generator   ║
║                                           ║
╚═══════════════════════════════════════════╝

USAGE:
    # Generate documentation for arty.sh project
    leaf.sh [project-dir] [options]
    
    # Generate butter.sh landing page
    leaf.sh --landing [options]

OPTIONS:
    --landing              Generate butter.sh landing page
    --logo PATH            Path to logo/icon file
    --base-path PATH       Base path for HTML links (default: /)
    --github URL           GitHub organization URL
    --projects JSON        JSON array of projects
    --projects-file FILE   JSON file containing projects
    -o, --output DIR       Output directory (default: docs)
    -h, --help             Show this help
    --debug                Enable debug output

EXAMPLES:
    # Generate docs for current directory
    leaf.sh .

    # Generate docs for specific project
    leaf.sh /path/to/project --logo ./icon.svg

    # Generate landing page
    leaf.sh --landing --projects-file ./projects.json

EOF
}

# Parse args
parse_args() {
  local projects_json=""
  PROJECTS_JSON=""
  
  while [[ $# -gt 0 ]]; do
    case $1 in
    -h | --help)
      show_usage
      exit 0
      ;;
    --debug)
      DEBUG=1
      shift
      ;;
    --landing)
      MODE="landing"
      shift
      ;;
    --logo)
      LOGO_PATH="$2"
      shift 2
      ;;
    --base-path)
      BASE_PATH="$2"
      shift 2
      ;;
    --github)
      GITHUB_URL="$2"
      shift 2
      ;;
    --projects)
      projects_json="$2"
      shift 2
      ;;
    --projects-file)
      PROJECTS_FILE="$2"
      shift 2
      ;;
    -o | --output)
      OUTPUT_DIR="$2"
      shift 2
      ;;
    -*)
      log_error "Unknown option: $1"
      show_usage
      exit 1
      ;;
    *)
      PROJECT_DIR="$1"
      shift
      ;;
    esac
  done
  
  [[ -n "$projects_json" ]] && PROJECTS_JSON="$projects_json"
  [[ -z "$PROJECT_DIR" ]] && PROJECT_DIR="."
  
  if [[ -z "$OUTPUT_DIR" ]]; then
    [[ "$MODE" == "landing" ]] && OUTPUT_DIR="output" || OUTPUT_DIR="${PROJECT_DIR}/docs"
  fi
}

# Parse YAML
parse_yaml() {
  local file="$1"
  local key="$2"
  
  [[ ! -f "$file" ]] && echo "" && return
  
  local value=$(yq eval ".${key}" "$file" 2>/dev/null | grep -v '^null$' || echo "")
  log_debug "Parsed ${key} from ${file}: ${value}"
  echo "$value"
}

# Read file safely
read_file() {
  local file="$1"
  [[ -f "$file" ]] && cat "$file" || echo ""
}

# Escape MyST.sh template syntax by replacing with HTML entities
# This prevents MyST from processing them while keeping them visible in output
escape_myst_for_display() {
  local text="${1:-}"
  
  # If no parameter, read from stdin
  if [[ -z "$text" ]]; then
    text=$(cat)
  fi
  
  # If still empty, return empty
  if [[ -z "$text" ]]; then
    return
  fi
  
  # Replace {{ with &#123;&#123; and }} with &#125;&#125;
  # These HTML entities will display as {{ and }} in the browser
  # but won't be processed by MyST.sh
  # NOTE: We do NOT escape backticks here because jq -Rs will properly
  # escape them for JSON/JavaScript strings
  printf '%s' "$text" | python3 -c 'import sys; text = sys.stdin.read(); text = text.replace("{{" , "&#123;&#123;").replace("}}", "&#125;&#125;"); sys.stdout.write(text)'
}

# Get icon path
get_icon() {
  if [[ -n "$LOGO_PATH" && -f "$LOGO_PATH" ]]; then
    echo "$LOGO_PATH"
    return
  fi
  
  local icon_dir="${PROJECT_DIR}/_assets/icon"
  local icon_files=("icon.svg" "icon-v2.svg" "icon-simple.svg" "icon.png")
  
  for icon_file in "${icon_files[@]}"; do
    if [[ -f "${icon_dir}/${icon_file}" ]]; then
      echo "${icon_dir}/${icon_file}"
      return
    fi
  done
  
  echo ""
}

# Detect language
detect_language() {
  local file="$1"
  local ext="${file##*.}"
  
  case "$ext" in
  sh | bash) echo "bash" ;;
  js) echo "javascript" ;;
  ts) echo "typescript" ;;
  py) echo "python" ;;
  rb) echo "ruby" ;;
  go) echo "go" ;;
  rs) echo "rust" ;;
  java) echo "java" ;;
  c | h) echo "c" ;;
  cpp | cc | cxx | hpp) echo "cpp" ;;
  *) echo "plaintext" ;;
  esac
}

# Scan source files
scan_source_files() {
  local files=()
  
  while IFS= read -r -d $'\0' file; do
    local rel_path="${file#${PROJECT_DIR}/}"
    local basename_file=$(basename "$rel_path")
    
    # Skip if: path starts with excluded dirs, contains .min., or basename starts with .
    if [[ "$rel_path" =~ ^(docs|examples|node_modules|__tests|\.git|\.arty)/ ]] || \
       [[ "$rel_path" =~ \.min\. ]] || \
       [[ "$basename_file" =~ ^\. ]]; then
      continue
    fi
    
    files+=("$file")
  done < <(find "$PROJECT_DIR" -type f \( -name "*.sh" -o -name "*.bash" -o -name "*.js" -o -name "*.py" \) -print0 2>/dev/null || true)
  
  printf '%s\n' "${files[@]}"
}

# Scan examples
scan_examples() {
  local examples_dir="${PROJECT_DIR}/examples"
  local examples=()
  
  [[ ! -d "$examples_dir" ]] && return
  
  while IFS= read -r -d $'\0' file; do
    examples+=("$file")
  done < <(find "$examples_dir" -type f -print0 2>/dev/null || true)
  
  printf '%s\n' "${examples[@]}"
}

# Generate source files HTML with escaped code
generate_source_html() {
  local sources=("$@")
  local html=""
  
  for file in "${sources[@]}"; do
    [[ ! -f "$file" ]] && continue
    local name=$(basename "$file")
    local rel="${file#${PROJECT_DIR}/}"
    local lang=$(detect_language "$file")
    
    # Read and escape HTML special characters in code
    local code=""
    if [[ -f "$file" ]] && [[ -r "$file" ]]; then
      code=$(cat "$file")
      if [[ -n "$code" ]]; then
        code=$(escape_html "$code")
        log_debug "Read ${#code} chars from $name"
      else
        log_debug "File $name is empty"
      fi
    else
      log_warn "Cannot read file: $file"
    fi
    
    html+="<div class=\"source-file card-project rounded-xl overflow-hidden\">"
    html+="<div class=\"source-file-header px-6 py-4 flex items-center justify-between\">"
    html+="<div><h3 class=\"text-xl font-semibold\" style=\"color: var(--carbon-light);\">${name}</h3>"
    html+="<p class=\"text-slate-300 text-sm\">${rel}</p></div>"
    html+="<svg class=\"chevron w-6 h-6\" style=\"color: var(--carbon-light);\" fill=\"none\" stroke=\"currentColor\" viewBox=\"0 0 24 24\"><path stroke-linecap=\"round\" stroke-linejoin=\"round\" stroke-width=\"2\" d=\"M19 9l-7 7-7-7\"/></svg>"
    html+="</div>"
    html+="<div class=\"source-file-content\"><div class=\"p-6\"><pre><code class=\"language-${lang}\">${code}</code></pre></div></div></div>"
  done
  
  [[ -z "$html" ]] && html="<p class=\"text-center text-slate-300\">No source files found.</p>"
  echo "$html"
}

# Generate examples HTML with escaped code
generate_examples_html() {
  local examples=("$@")
  local html=""
  
  for file in "${examples[@]}"; do
    [[ ! -f "$file" ]] && continue
    local name=$(basename "$file")
    local lang=$(detect_language "$file")
    
    # Read and escape HTML special characters in code
    local code=""
    if [[ -f "$file" ]] && [[ -r "$file" ]]; then
      code=$(cat "$file")
      if [[ -n "$code" ]]; then
        code=$(escape_html "$code")
      fi
    fi
    
    html+="<div class=\"card-project rounded-xl overflow-hidden\">"
    html+="<div class=\"px-6 py-4\" style=\"background: rgba(134, 239, 172, 0.15);\">"
    html+="<h3 class=\"text-xl font-semibold\" style=\"color: var(--carbon-light);\">${name}</h3></div>"
    html+="<div class=\"p-6\"><pre><code class=\"language-${lang}\">${code}</code></pre></div></div>"
  done
  
  [[ -z "$html" ]] && html="<p class=\"text-center text-slate-300\">No examples found.</p>"
  echo "$html"
}

# Generate documentation
generate_docs_page() {
  log_info "Generating documentation..."
  
  local arty_yml="${PROJECT_DIR}/arty.yml"
  local readme_md="${PROJECT_DIR}/README.md"
  
  # Parse metadata
  local project_name=$(parse_yaml "$arty_yml" "name")
  local project_version=$(parse_yaml "$arty_yml" "version")
  local project_desc=$(parse_yaml "$arty_yml" "description")
  
  [[ -z "$project_name" ]] && project_name=$(basename "$PROJECT_DIR")
  
  # Read README - we have two versions:
  # 1. readme_content: for display in HTML (with MyST escaping)
  # 2. readme_for_json: for JSON script tag (no MyST escaping needed)
  local readme_content=$(read_file "$readme_md")
  [[ -z "$readme_content" ]] && readme_content="No README.md file found."
  
  log_debug "README before escaping (first 200 chars): ${readme_content:0:200}"
  
  # For HTML display, escape MyST syntax
  local readme_html=$(escape_myst_for_display "$readme_content")
  
  # For JSON, use the original content without MyST escaping
  # (JSON.parse will handle everything correctly)
  local readme_for_json="$readme_content"
  
  log_debug "README for HTML (first 200 chars): ${readme_html:0:200}"
  log_debug "README for JSON (first 200 chars): ${readme_for_json:0:200}"
  
  # Get icon - DON'T escape here, let the template handle it
  local icon_path=$(get_icon)
  local icon_svg=""
  if [[ -n "$icon_path" ]]; then
    icon_svg=$(cat "$icon_path")
    log_success "Loaded icon: ${icon_path#${PROJECT_DIR}/}"
  else
    icon_svg='<svg class="w-full h-full" fill="currentColor" viewBox="0 0 24 24"><path d="M13 2L3 14h9l-1 8 10-12h-9l1-8z"/></svg>'
  fi
  
  # Scan files
  local source_files=($(scan_source_files))
  local example_files=($(scan_examples))
  
  log_info "Found ${#source_files[@]} source files and ${#example_files[@]} examples"
  
  # Check if we have examples
  local has_examples="false"
  if [[ ${#example_files[@]} -gt 0 ]]; then
    has_examples="true"
  fi
  
  # Generate HTML (already escaped)
  local src_html=$(generate_source_html "${source_files[@]}")
  local ex_html=$(generate_examples_html "${example_files[@]}")
  
  # Create JSON data file
  local data_file="/tmp/leaf_docs_$.json"
  
  # For the JSON script tag, we need readme_content_json to be a properly formatted JSON value
  # Use jq to convert the string to a JSON string (adds quotes and escapes special chars)
  # Use the unescaped version (readme_for_json) so HTML entities don't break JSON.parse
  local readme_json=$(printf '%s' "$readme_for_json" | jq -Rs '.')
  
  log_debug "README as JSON string (first 200 chars): ${readme_json:0:200}"
  
  # For large HTML content, write to temp files as raw text
  local src_html_file="/tmp/leaf_src_$.txt"
  local ex_html_file="/tmp/leaf_ex_$.txt"
  
  # Write HTML content as raw text to files
  printf '%s' "$src_html" > "$src_html_file"
  printf '%s' "$ex_html" > "$ex_html_file"
  
  # Build JSON file, reading and encoding the large content from files
  # Note: --rawfile includes trailing newlines, so we trim them with rtrimstr
  jq -n \
    --arg name "$project_name" \
    --arg version "${project_version:-1.0.0}" \
    --arg desc "${project_desc:-Documentation}" \
    --arg icon "$icon_svg" \
    --arg readme "$readme_html" \
    --arg readme_json "$readme_json" \
    --arg github "$GITHUB_URL" \
    --arg base "$BASE_PATH" \
    --arg has_examples "$has_examples" \
    --rawfile src_html "$src_html_file" \
    --rawfile ex_html "$ex_html_file" \
    '{
      page_title: ($name + " - Documentation"),
      page_description: $desc,
      base_path: $base,
      project_name: $name,
      project_version: $version,
      project_description: $desc,
      icon: $icon,
      readme_content: $readme,
      readme_content_json: $readme_json,
      github_url: $github,
      source_files_html: $src_html,
      examples_html: $ex_html,
      has_examples: $has_examples,
      myst_enabled: "true"
    }' >"$data_file"
  
  # Clean up temp files
  rm -f "$src_html_file" "$ex_html_file"
  
  # Render
  if ! render_with_myst \
    "${TEMPLATES_DIR}/docs.html.myst" \
    "${OUTPUT_DIR}/index.html" \
    "$data_file"; then
    log_error "Failed to render documentation"
    rm -f "$data_file"
    return 1
  fi
  
  # Keep JSON for debugging if DEBUG is set
  if [[ "${DEBUG:-0}" == "1" ]]; then
    cp "$data_file" "${OUTPUT_DIR}/debug-data.json"
    log_debug "Saved debug data to ${OUTPUT_DIR}/debug-data.json"
  else
    # Always save for troubleshooting for now
    cp "$data_file" "${OUTPUT_DIR}/debug-data.json"
  fi
  
  rm -f "$data_file"
  log_success "Documentation generated: ${OUTPUT_DIR}/index.html"
}

# Generate landing page
generate_landing_page() {
  log_info "Generating landing page..."
  
  mkdir -p "$OUTPUT_DIR"
  
  local projects_default='[{"url":"https://hammer.sh","label":"hammer.sh","desc":"Configurable bash project generator","class":"card-project"},{"url":"https://arty.sh","label":"arty.sh","desc":"Bash library repository manager","class":"card-project"},{"url":"https://leaf.sh","label":"leaf.sh","desc":"Beautiful documentation generator","class":"card-project"}]'
  
  local projects=""
  
  # Load projects
  if [[ -n "$PROJECTS_FILE" ]] && [[ -f "$PROJECTS_FILE" ]]; then
    projects=$(jq -c '.' "$PROJECTS_FILE")
    log_success "Loaded projects from: $PROJECTS_FILE"
  elif [[ -n "$PROJECTS_JSON" ]]; then
    projects="$PROJECTS_JSON"
    log_success "Using projects from command line"
  else
    projects="$projects_default"
    log_info "Using default projects"
  fi
  
  # Get logo
  local logo_svg=""
  if [[ -n "$LOGO_PATH" && -f "$LOGO_PATH" ]]; then
    logo_svg=$(cat "$LOGO_PATH")
  else
    logo_svg='<svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/><polyline points="3.27 6.96 12 12.01 20.73 6.96"/><line x1="12" y1="22.08" x2="12" y2="12"/></svg>'
  fi
  
  # Create JSON
  local data_file="/tmp/leaf_landing_$$.json"
  
  jq -n \
    --arg logo "$logo_svg" \
    --arg base "$BASE_PATH" \
    --arg github "$GITHUB_URL" \
    --argjson projects_json_data "$projects" \
    '{
      page_title: "butter.sh - Modern Bash Development Ecosystem",
      page_description: "A collection of modern bash development tools",
      base_path: $base,
      logo: $logo,
      site_name: "butter.sh",
      github_url: $github,
      hero_tagline: "Modern bash development tools for the command line renaissance",
      primary_cta_text: "Explore Projects",
      primary_cta_url: $github,
      secondary_cta_text: "Learn More",
      secondary_cta_url: "#projects",
      projects_section_title: "Our Projects",
      projects_json: $projects_json_data,
      footer_tagline: "Building the future of bash development",
      generator_credit: "true",
      myst_enabled: "true"
    }' >"$data_file"
  
  # Render
  if ! render_with_myst \
    "${TEMPLATES_DIR}/landing.html.myst" \
    "${OUTPUT_DIR}/index.html" \
    "$data_file"; then
    log_error "Failed to render landing page"
    rm -f "$data_file"
    return 1
  fi
  
  rm -f "$data_file"
  log_success "Landing page generated: ${OUTPUT_DIR}/index.html"
}

# Main
main() {
  parse_args "$@"
  
  # Show help if no project dir and not landing mode
  if [[ -z "$PROJECT_DIR" ]] && [[ "$MODE" != "landing" ]]; then
    show_usage
    exit 1
  fi
  
  if ! check_dependencies; then
    exit 1
  fi
  
  if [[ "${LEAF_TEST_MODE:-0}" != "1" ]]; then
    echo -e "${CYAN}╔═══════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║      🌿 leaf.sh Generator v2.0 🌿        ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════╝${NC}"
    echo ""
  fi
  
  if [[ "$MODE" == "landing" ]]; then
    generate_landing_page
  else
    if [[ ! -d "$PROJECT_DIR" ]]; then
      log_error "Project directory not found: $PROJECT_DIR"
      exit 1
    fi
    
    log_info "Scanning project: $PROJECT_DIR"
    generate_docs_page
  fi
  
  if [[ "${LEAF_TEST_MODE:-0}" != "1" ]]; then
    echo ""
    echo -e "${GREEN}Generation complete! 🎉${NC}"
    echo -e "📂 Output: ${CYAN}${OUTPUT_DIR}/index.html${NC}"
  fi
}

# Run main
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
