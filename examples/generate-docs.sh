#!/usr/bin/env bash
# Example: Generate documentation for a project

# Generate docs for current directory
./leaf.sh

# Generate docs for specific project with custom logo
./leaf.sh /path/to/myproject --logo ./myproject/icon.svg

# Generate docs with custom output directory
./leaf.sh /path/to/myproject -o ./public/docs

# Generate docs with custom base path (for subdirectory hosting)
./leaf.sh /path/to/myproject --base-path /docs/ -o ./public/docs
