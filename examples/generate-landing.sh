#!/usr/bin/env bash
# Example: Generate a landing page for butter.sh

# Create a projects.json file
cat > projects.json << 'EOF'
[
  {
    "url": "https://hammer.sh",
    "label": "hammer.sh",
    "desc": "Configurable bash project generator",
    "class": "card-project"
  },
  {
    "url": "https://arty.sh",
    "label": "arty.sh",
    "desc": "Bash library repository manager",
    "class": "card-project"
  },
  {
    "url": "https://leaf.sh",
    "label": "leaf.sh",
    "desc": "Beautiful documentation generator",
    "class": "card-project"
  },
  {
    "url": "https://whip.sh",
    "label": "whip.sh",
    "desc": "Release cycle management tool",
    "class": "card-project"
  }
]
EOF

# Generate landing page
./leaf.sh --landing \
  --projects-file ./projects.json \
  --github https://github.com/butter-sh \
  --logo ./brand-logo.svg \
  -o ./landing

echo "Landing page generated at: ./landing/index.html"

# Clean up
rm projects.json
