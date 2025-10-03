#!/bin/bash

msg=$1

# Commit and push submodules
git submodule foreach "
  git add .
  git commit -m '${msg:-"update"}'
  git push origin \$(git rev-parse --abbrev-ref HEAD)
"

# Commit and push the main repository
git add .
git commit -m '${msg:-"update"}'
git push origin main


