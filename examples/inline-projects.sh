#!/usr/bin/env bash
# Example: Generate landing page with inline projects JSON

./leaf.sh --landing \
  --projects '[
    {"url":"https://example.com/app1","label":"App One","desc":"First application","class":"card-project"},
    {"url":"https://example.com/app2","label":"App Two","desc":"Second application","class":"card-project"}
  ]' \
  --github https://github.com/myorg \
  -o ./output

echo "Landing page with inline projects generated!"
